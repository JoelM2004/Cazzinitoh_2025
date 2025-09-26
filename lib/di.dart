import 'package:cazzinitoh_2025/src/features/users/data/datasource/user_local_datasource.dart';
import 'package:cazzinitoh_2025/src/features/users/data/datasource/user_remote_datasource.dart';
import 'package:cazzinitoh_2025/src/features/users/data/repositories/user_repository_impl.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/repositories/user_repository.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/use_cases/get_user.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/use_cases/login.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/load_user/load_user_bloc.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/login_user/login_user_bloc.dart';
import 'package:get_it/get_it.dart';

final di = GetIt.instance;

Future<void> init() async {
  // External dependencies can be registered here
  di.registerFactory(() => LoadUserBloc(di()));
  di.registerFactory(() => LoginUserBloc(di()));

  di.registerLazySingleton(() => GetUserUseCase(repository: di()));
  di.registerLazySingleton(() => LoginUseCase(repository: di()));

  di.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      userLocalDataSource: di(),
      userRemoteDatasource: di(),
    ),
  );

  di.registerLazySingleton<UserLocalDataSource>(
    () =>
        HiveUserLocalDataSourceImpl(), //acá lo puedo cambiar a otro local datasource si quiero, como mysql
  );

  di.registerLazySingleton<UserRemoteDatasource>(
    () => UserRemoteDataSourceImpl(),
  );
}
