import 'package:cazzinitoh_2025/src/core/location/location_service.dart';
import 'package:cazzinitoh_2025/src/features/games/data/datasource/game_remote_datasource.dart';
import 'package:cazzinitoh_2025/src/features/games/data/repositories/game_repository_impl.dart';
import 'package:cazzinitoh_2025/src/features/games/domain/repositories/game_repository.dart';
import 'package:cazzinitoh_2025/src/features/games/domain/use_cases/save_leaderboard_entry_usecase.dart';
import 'package:cazzinitoh_2025/src/features/games/domain/use_cases/update_stats_usecase.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/blocs/game_bloc.dart';
import 'package:get_it/get_it.dart';

void registerGameDependencies(GetIt di) {
  // Bloc
  di.registerFactory(
    () => GameBloc(
      locationService: di<LocationService>(),
      saveScore: di<SaveScoreUseCase>(),
      saveStats: di<SaveStatsUseCase>(),
    ),
  );

  // Use cases — constructor posicional, sin named parameter
  di.registerLazySingleton(() => SaveScoreUseCase(di<GameRepository>()));
  di.registerLazySingleton(() => SaveStatsUseCase(di<GameRepository>()));

  // Repository
  di.registerLazySingleton<GameRepository>(
    () => GameRepositoryImpl(remoteDatasource: di()),
  );

  // Data source
  di.registerLazySingleton<GameRemoteDatasource>(
    () => GameRemoteDatasourceImpl(),
  );
}