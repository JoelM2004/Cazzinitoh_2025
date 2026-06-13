import 'package:cazzinitoh_2025/src/core/location/location_service.dart';
import 'package:cazzinitoh_2025/src/features/games/data/datasource/game_remote_datasource.dart';
import 'package:cazzinitoh_2025/src/features/games/data/repositories/game_repository_impl.dart';
import 'package:cazzinitoh_2025/src/features/games/domain/repositories/game_repository.dart';
import 'package:cazzinitoh_2025/src/features/games/domain/use_cases/get_stats_use_case.dart';
import 'package:cazzinitoh_2025/src/features/games/domain/use_cases/get_user_scores_usecase.dart';
import 'package:cazzinitoh_2025/src/features/games/domain/use_cases/save_leaderboard_entry_usecase.dart';
import 'package:cazzinitoh_2025/src/features/games/domain/use_cases/update_stats_usecase.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/blocs/game_bloc.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/blocs/stats/stats_bloc.dart';
import 'package:get_it/get_it.dart';

void registerGameDependencies(GetIt di) {
  // Blocs
  di.registerFactory(
    () => GameBloc(
      locationService: di<LocationService>(),
      saveScore: di<SaveScoreUseCase>(),
      saveStats: di<SaveStatsUseCase>(),
    ),
  );
  di.registerFactory(
  () => StatsBloc(
    getStats: di<GetStatsUseCase>(),
    getUserScores: di<GetUserScoresUseCase>(),
  ),
);

  // Use cases
  di.registerLazySingleton(() => SaveScoreUseCase(di<GameRepository>()));
  di.registerLazySingleton(() => SaveStatsUseCase(di<GameRepository>()));
  di.registerLazySingleton(() => GetStatsUseCase(di<GameRepository>()));
  di.registerLazySingleton(() => GetUserScoresUseCase(di<GameRepository>()));

  // Repository
  di.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(remoteDatasource: di()),
  );

  // Data source
  di.registerLazySingleton<GameRemoteDatasource>(
    () => GameRemoteDatasourceImpl(),
  );
}