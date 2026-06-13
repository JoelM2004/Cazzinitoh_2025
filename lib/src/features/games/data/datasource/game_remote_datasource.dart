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

  Future<List<ScoreLeaderboardModel>> getUserScores(String userId);

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
        Query.equal('userId', userId), // ← era 'users', incorrecto
        Query.limit(1),
      ],
    );

    if (result.documents.isEmpty) {
      // Retornar stats vacías en vez de tirar error (usuario nuevo)
      return StatsModel(
        userId: userId,
        mts: 0,
        time: 0,
        matchs: 0,
        accuracy: 0,
      );
    }

    return StatsModel.fromJson(result.documents.first.data);
  } on AppwriteException catch (e) {
    throw ServerFailure(message: e.message ?? 'Error al obtener stats');
  }
}

  @override
  Future<StatsModel> saveStats(StatsModel stats) async {
    try {
      final result = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.statsCollectionId,
        queries: [
          Query.equal('userId', stats.userId), // Ojo: asegúrate que en la base de datos la columna se llame 'users'
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

      final totalMatches = currentStats.matchs + stats.matchs;
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
    } catch (e) {
      throw ServerFailure(message: 'Error inesperado al procesar las estadísticas');
    }
  }

  @override
Future<void> saveScore(int score) async {
  try {
    final currentUser = await _account.get();
    print('🟡 [DATASOURCE] saveScore - userId: ${currentUser.$id}, score: $score');

    // Siempre crea un documento nuevo con ID único → historial completo
    await _databases.createDocument(
  databaseId: AppwriteConfig.databaseId,
  collectionId: AppwriteConfig.leaderboardCollectionId,
  documentId: ID.unique(),
  data: {
    'score': score,
    'user': currentUser.$id, // 👈 string directo, sin array
  },
);
    print('🟢 [DATASOURCE] Partida guardada en leaderboard');
  } on AppwriteException catch (e) {
    print('🔴 [DATASOURCE] saveScore error: code=${e.code}, msg=${e.message}');
    throw ServerFailure(message: e.message ?? 'Error al guardar score');
  } catch (e, stack) {
    print('🔴 [DATASOURCE] saveScore error desconocido: $e');
    print('🔴 stack: $stack');
    throw ServerFailure(message: 'Error inesperado al guardar score');
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
        Query.select(['*', 'user.*']),
      ],
    );

    final currentAccount =
        await _account.get().catchError((_) => null);

    final allScores = result.documents.map((doc) {
      final user = UserModel.fromJson(
  Map<String, dynamic>.from(
    doc.data['user'] as Map<String, dynamic>, // 👈 ya no es lista
  ),
);

      return ScoreLeaderboardModel(
        user: user,
        score: (doc.data['score'] as num).toInt(),
        isCurrentUser: user.id == currentAccount?.$id,
      );
    }).toList();

    // Mejor score por usuario
    final Map<String, ScoreLeaderboardModel> bestByUser = {};
    for (final entry in allScores) {
      final existing = bestByUser[entry.user.id];
      if (existing == null || entry.score > existing.score) {
        bestByUser[entry.user.id] = entry;
      }
    }

    // Top 10 ordenados por score desc
    final top10 = bestByUser.values.toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return top10.take(10).toList();
  } on AppwriteException catch (e) {
    throw ServerFailure(
      message: e.message ?? 'Error al obtener leaderboard',
    );
  }
}

  @override
Future<List<ScoreLeaderboardModel>> getUserScores(String userId) async {
  try {
    final allDocs = <dynamic>[];
    int offset = 0;
    const pageSize = 25;

    while (true) {
      final result = await _databases.listDocuments(
        databaseId: AppwriteConfig.databaseId,
        collectionId: AppwriteConfig.leaderboardCollectionId,
        queries: [
          Query.equal('user', [userId]),
          Query.orderDesc('score'),
          Query.limit(pageSize),
          Query.offset(offset),
          Query.select(['*', 'user.*']),
        ],
      );

      allDocs.addAll(result.documents);
      if (result.documents.length < pageSize) break;
      offset += pageSize;
    }

    return allDocs.map((doc) {
      final user = UserModel.fromJson(
        Map<String, dynamic>.from(
          (doc.data['user'] as List).first,
        ),
      );
      return ScoreLeaderboardModel(
        user: user,
        score: (doc.data['score'] as num).toInt(),
        isCurrentUser: true,
      );
    }).toList();
  } on AppwriteException catch (e) {
    throw ServerFailure(message: e.message ?? 'Error al obtener partidas del usuario');
  }
}
}