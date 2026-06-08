// import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:cazzinitoh_2025/src/features/users/data/models/stats_model.dart';
// import 'package:cazzinitoh_2025/src/features/users/data/models/score_leaderboard_model.dart';

// class GameLocalDatasourceImpl implements GameLocalDatasource {
//   final SharedPreferences prefs;

//   static const String _statsPrefix = 'game_stats_user_';
//   static const String _leaderboardKey = 'game_leaderboard_cache';

//   GameLocalDatasourceImpl({
//     required this.prefs,
//   });

//   @override
//   Future<void> cacheStats(StatsModel stats) async {
//     final key = '$_statsPrefix${stats.userId}';

//     await prefs.setString(
//       key,
//       jsonEncode(stats.toJson()),
//     );
//   }

//   @override
//   Future<StatsModel?> getCachedStats(String userId) async {
//     final key = '$_statsPrefix$userId';

//     final raw = prefs.getString(key);

//     if (raw == null) return null;

//     try {
//       return StatsModel.fromJson(
//         jsonDecode(raw) as Map<String, dynamic>,
//       );
//     } catch (_) {
//       return null;
//     }
//   }

//   @override
//   Future<void> cacheLeaderboard(
//     List<ScoreLeaderboardModel> entries,
//   ) async {
//     final encoded = jsonEncode(
//       entries.map((e) => e.toJson()).toList(),
//     );

//     await prefs.setString(
//       _leaderboardKey,
//       encoded,
//     );
//   }

//   @override
//   Future<List<ScoreLeaderboardModel>> getCachedLeaderboard() async {
//     final raw = prefs.getString(_leaderboardKey);

//     if (raw == null) return [];

//     try {
//       final list = jsonDecode(raw) as List<dynamic>;

//       return list
//           .map(
//             (e) => ScoreLeaderboardModel.fromJson(
//               e as Map<String, dynamic>,
//             ),
//           )
//           .toList();
//     } catch (_) {
//       return [];
//     }
//   }

//   @override
//   Future<void> clearGameCache() async {
//     final keysToRemove = prefs
//         .getKeys()
//         .where(
//           (key) =>
//               key.startsWith(_statsPrefix) ||
//               key == _leaderboardKey,
//         )
//         .toList();

//     for (final key in keysToRemove) {
//       await prefs.remove(key);
//     }
//   }
// }