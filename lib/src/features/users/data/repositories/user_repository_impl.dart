import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/data/datasource/user_local_datasource.dart';
import 'package:cazzinitoh_2025/src/features/users/data/datasource/user_remote_datasource.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/stats.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/user.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource userLocalDataSource;
  final UserRemoteDatasource userRemoteDatasource;

  UserRepositoryImpl({
    required this.userLocalDataSource,
    required this.userRemoteDatasource,
  });

  @override
  Future<Either<Failure, bool>> cacheUser(User user) async {
    try {
      final bool resp = await userLocalDataSource.cacheUser(user);
      return Right(resp);
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getUser(int id) async {
    try {
      final User user = await userRemoteDatasource.getUser(id);
      return Right(user);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Stats>> getStats(int id) async {
    try {
      final Stats stats = await userRemoteDatasource.getStats(id);
      return Right(stats);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> login(String email, String password) async {
    try {
      final bool resp = await userRemoteDatasource.login(email, password);
      return Right(resp);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> register(String email, String password) async {
    try {
      final bool resp = await userRemoteDatasource.register(email, password);
      return Right(resp);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final bool resp = await userRemoteDatasource.logout();
      return Right(resp);
    } on ServerFailure {
      return Left(ServerFailure());
    }
  }
}
