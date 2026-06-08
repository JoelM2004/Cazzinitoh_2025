import 'package:appwrite/appwrite.dart';
import 'package:cazzinitoh_2025/src/core/appwrite/appwrite_client.dart';
import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/stats_model.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/score_leaderboard_model.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';

abstract class GameRemoteDatasource {
  /// Obtiene las estadísticas de un usuario.
  Future<StatsModel> getStats(String userId);

  /// Crea o actualiza las estadísticas del usuario.
  Future<StatsModel> saveStats(StatsModel stats);

  /// Guarda/actualiza el score del usuario en el leaderboard.
  Future<void> saveScore(int score);

  /// Obtiene el leaderboard ordenado por score.
  Future<List<ScoreLeaderboardModel>> getLeaderboard();
}

class GameRemoteDatasourceImpl implements GameRemoteDatasource {
  final Client _client = AppwriteConfig.client;
  late final Databases _databases;
  late final Account _account;

  GameRemoteDatasourceImpl() {
    _databases = Databases(_client);
    _account = Account(_client);
  }

  @override
  Future<StatsModel> getStats(String userId) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.statsCollectionId,
        queries: [
          Query.equal('users', userId),
          Query.limit(1),
        ],
      );

      if (result.documents.isEmpty) {
        throw ServerFailure(message: 'No existen estadísticas');
      }

      return StatsModel.fromJson(result.documents.first.data);
    } on AppwriteException catch (e) {
      throw ServerFailure(
        message: e.message ?? 'Error al obtener stats',
      );
    }
  }

  @override
  Future<StatsModel> saveStats(StatsModel stats) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.statsCollectionId,
        queries: [
          Query.equal('users', stats.userId),
          Query.limit(1),
        ],
      );

      // Primera partida del usuario
      if (result.documents.isEmpty) {
        final doc = await _databases.createDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.statsCollectionId,
          documentId: ID.unique(),
          data: stats.toJson(),
        );

        return StatsModel.fromJson(doc.data);
      }

      final currentStats = StatsModel.fromJson(
        result.documents.first.data,
      );

      final totalMatches =
          currentStats.matchs + stats.matchs;

      final averageAccuracy =
          ((currentStats.accuracy * currentStats.matchs) +
                  (stats.accuracy * stats.matchs)) /
              totalMatches;

      final updatedStats = StatsModel(
        userId: currentStats.userId,
        mts: currentStats.mts + stats.mts,
        time: currentStats.time + stats.time,
        matchs: totalMatches,
        accuracy: averageAccuracy,
      );

      final doc = await _databases.updateDocument(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.statsCollectionId,
        documentId: result.documents.first.$id,
        data: updatedStats.toJson(),
      );

      return StatsModel.fromJson(doc.data);
    } on AppwriteException catch (e) {
      throw ServerFailure(
        message: e.message ?? 'Error al guardar stats',
      );
    }
  }

  @override
  Future<void> saveScore(int score) async {
    try {
      final currentUser = await _account.get();

      final result = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.leaderboardCollectionId,
        queries: [
          Query.equal('users', currentUser.$id),
          Query.limit(1),
        ],
      );

      if (result.documents.isEmpty) {
        await _databases.createDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.leaderboardCollectionId,
          documentId: ID.unique(),
          data: {
            'score': score,
            'users': currentUser.$id,
          },
        );
        return;
      }
      final currentBest =
      (result.documents.first.data['score'] as num).toInt();

      if (score > currentBest) {
        await _databases.updateDocument(
          databaseId: AppwriteConfig.databaseId,
          collectionId: AppwriteConfig.leaderboardCollectionId,
          documentId: result.documents.first.$id,
          data: {
            'score': score,
          },
        );
      }
    } on AppwriteException catch (e) {
      throw ServerFailure(
        message: e.message ?? 'Error al guardar score',
      );
    }
  }

  @override
  Future<List<ScoreLeaderboardModel>> getLeaderboard() async {
    try {
      final result = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.leaderboardCollectionId,
        queries: [
          Query.orderDesc('score'),
          Query.limit(100),
          Query.select(['*', 'users.*']),
        ],
      );

      final currentAccount =
          await _account.get().catchError((_) => null);

      return result.documents.map((doc) {
        final user = UserModel.fromJson(
          Map<String, dynamic>.from(
            (doc.data['users'] as List).first,
          ),
        );

        return ScoreLeaderboardModel(
          user: user,
          score: (doc.data['score'] as num).toInt(),
          isCurrentUser: user.id == currentAccount?.$id,
        );
      }).toList();
    } on AppwriteException catch (e) {
      throw ServerFailure(
        message: e.message ?? 'Error al obtener leaderboard',
      );
    }
  }
}