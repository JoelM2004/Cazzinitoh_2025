import 'package:cazzinitoh_2025/src/features/users/data/datasource/user_local_datasource.dart';
import 'package:cazzinitoh_2025/src/features/users/data/datasource/user_remote_datasource.dart';
import 'package:cazzinitoh_2025/src/features/users/data/repositories/user_repository_impl.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/repositories/user_repository.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/use_cases/get_leaderboard_use_case.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/use_cases/get_user.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/use_cases/login.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/use_cases/register.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/use_cases/update.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/leaderboard/leaderboard_bloc.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/load_user/load_user_bloc.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/login_user/login_user_bloc.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/register_user/register_user_bloc.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/update_user/update_user_bloc.dart';
import 'package:get_it/get_it.dart';

void registerUserDependencies(GetIt di) {
  // Blocs
  di.registerFactory(() => LoadUserBloc(di()));
  di.registerFactory(() => LoginUserBloc(di()));
  di.registerFactory(() => RegisterUserBloc(di()));
  di.registerFactory(() => UpdateUserBloc(di()));
  di.registerFactory(() => LeaderboardBloc(di()));

  // Use cases
  di.registerLazySingleton(() => GetUserUseCase(repository: di()));
  di.registerLazySingleton(() => LoginUseCase(repository: di()));
  di.registerLazySingleton(() => RegisterUseCase(repository: di()));
  di.registerLazySingleton(() => UpdateUseCase(repository: di()));
  di.registerLazySingleton(() => GetLeaderboardUseCase(repository: di()));

  // Repository
  di.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      userLocalDataSource: di(),
      userRemoteDatasource: di(),
    ),
  );

  // Data sources
  di.registerLazySingleton<UserLocalDataSource>(
    () => HiveUserLocalDataSourceImpl(),
  );
  di.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDataSourceImpl(),
  );
}