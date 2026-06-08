// lib/src/features/users/data/datasources/user_remote_datasource.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:cazzinitoh_2025/src/core/appwrite/appwrite_client.dart';
import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/core/session/session.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/stats_model.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/score_leaderboard_model.dart';

abstract class UserRemoteDatasource {
  Future<UserModel> getUser(String userId);
  Future<StatsModel> getStats(String userId);
  Future<bool> login(String email, String password);
  Future<bool> register(String email, String password);
  Future<bool> logout();
  Future<bool> update(
    String name,
    String nameTag,
    DateTime fecha,
    String? profilePictureUrl,
  );
  Future<List<ScoreLeaderboardModel>> getLeaderboard();
}

class UserRemoteDataSourceImpl implements UserRemoteDatasource {
  final Client _client = AppwriteConfig.client;
  late final Account _account;
  late final Databases _databases;
  late final Storage _storage;

  UserRemoteDataSourceImpl() {
    _account = Account(_client);
    _databases = Databases(_client);
    _storage = Storage(_client);
  }

  // ─── AUTH ────────────────────────────────────────────────────────────────

  @override
  Future<bool> login(String email, String password) async {
    try {

      try {
        await _account.deleteSession(sessionId: 'current');
      } catch (_) {} // ignorar si no había sesión

      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final result = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollectionId,
        queries: [Query.equal('email', email), Query.limit(1)],
      );

      if (result.documents.isNotEmpty) {
        Session.currentUser = _docToUserModel(result.documents.first);
        print('Usuario cargado: ${Session.currentUser!.name}');
      }

      return true;
    } on AppwriteException catch (e) {
      print(e.message);
      throw ServerFailure(message: e.message ?? 'Login fallido');
    }
  }

  @override
  Future<bool> register(String email, String password) async {
    try {

      try {
        await _account.deleteSession(sessionId: 'current');
      } catch (_) {} // ignorar si no había sesión


      final authUser = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );

      await _account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      await _databases.createDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollectionId,
        documentId: authUser.$id,
        data: {
          'name': 'Nuevo usuario',
          'nameTag': 'tag_${authUser.$id.substring(0, 8)}',
          'fechaNacimiento': DateTime.now().toIso8601String(),
          'email': email,
          'role': 1,
        },
      );



      print('Usuario registrado con ID: ${authUser.$id}');

      return true;
    } on AppwriteException catch (e) {
      throw ServerFailure(message: e.message ?? 'Registro fallido');
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      Session.currentUser = null;
      print('Sesión cerrada');
      return true;
    } on AppwriteException catch (e) {
      throw ServerFailure(message: e.message ?? 'Logout fallido');
    }
  }

  // ─── USUARIO ─────────────────────────────────────────────────────────────

  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final doc = await _databases.getDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollectionId,
        documentId: userId,
      );
      return _docToUserModel(doc);
    } on AppwriteException catch (e) {
      throw ServerFailure(message: e.message ?? 'Error al obtener usuario');
    }
  }

  @override
  Future<bool> update(
    String name,
    String nameTag,
    DateTime fechaNacimiento,
    String? profilePictureUrl,
  ) async {
    try {
      final account = await _account.get();
      final userId = account.$id;

      String? finalPictureUrl = profilePictureUrl;

      if (profilePictureUrl != null && !profilePictureUrl.startsWith('http')) {
        final file = await _storage.createFile(
          bucketId: AppwriteConfig.avatarsBucketId,
          fileId: ID.unique(),
          file: InputFile.fromPath(path: profilePictureUrl),
        );
        finalPictureUrl =
            '${AppwriteConfig.endpoint}/storage/buckets/${AppwriteConfig.avatarsBucketId}/files/${file.$id}/view?project=${AppwriteConfig.projectId}';
      }

      final Map<String, dynamic> data = {
        'name': name,
        'nameTag': nameTag,
        'fechaNacimiento': fechaNacimiento.toIso8601String(),
      };

      if (finalPictureUrl != null) {
        data['profilePictureUrl'] = finalPictureUrl;
      }

      await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.usersCollectionId,
        documentId: userId,
        data: data,
      );

      if (Session.currentUser != null) {
        Session.currentUser = UserModel(
          id: userId,
          name: name,
          nameTag: nameTag,
          fechaNacimiento: fechaNacimiento,
          email: Session.currentUser!.email,
          profilePictureUrl:
              finalPictureUrl ?? Session.currentUser!.profilePictureUrl,
          idAchievements: Session.currentUser!.idAchievements,
        );
      }

      return true;
    } on AppwriteException catch (e) {
      throw ServerFailure(message: e.message ?? 'Error al actualizar usuario');
    }
  }

  // ─── LEADERBOARD ─────────────────────────────────────────────────────────

 @override
Future<List<ScoreLeaderboardModel>> getLeaderboard() async {
  try {
    final result = await _databases.listDocuments(
      databaseId: AppwriteConfig.databaseId,
      collectionId: AppwriteConfig.leaderboardCollectionId,
      queries: [
        Query.orderDesc('score'),
        Query.limit(10),
        Query.select(['*', 'users.*']),
      ],
    );

    final currentAccount = await _account.get().catchError((_) => null);
    final currentUserId = currentAccount?.$id;

    return result.documents
        .where((doc) {
          final users = doc.data['users'];
          if (users == null || (users as List).isEmpty) {
            print('[Leaderboard] Documento sin user: ${doc.$id}');
            return false;
          }
          return true;
        })
        .map((doc) {
          final user = UserModel.fromJson(
            Map<String, dynamic>.from(
              (doc.data['users'] as List).first,
            ),
          );

          return ScoreLeaderboardModel(
            user: user,
            score: (doc.data['score'] as num).toInt(),
            isCurrentUser: user.id == currentUserId,
          );
        })
        .toList();
  } on AppwriteException catch (e) {
    throw ServerFailure(
      message: e.message ?? 'Error al obtener leaderboard',
    );
  }
}

  @override
  Future<StatsModel> getStats(String userId) async {
    throw UnimplementedError();
  }

  // ─── HELPER ──────────────────────────────────────────────────────────────

  UserModel _docToUserModel(models.Document doc) {
    final data = Map<String, dynamic>.from(doc.data);
    data['id'] = doc.$id;
    return UserModel.fromJson(data);
  }
}