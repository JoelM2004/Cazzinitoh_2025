// lib/src/features/users/data/repositories/user_repository_impl.dart

import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/data/datasource/user_local_datasource.dart';
import 'package:cazzinitoh_2025/src/features/users/data/datasource/user_remote_datasource.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/stats.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/user.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/repositories/user_repository.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/score_leaderboard_model.dart';
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
    } on LocalFailure catch (e) {  // ← capturá la variable
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, User>> getUser(int id) async {
    try {
      final User user = await userRemoteDatasource.getUser(id.toString());
      return Right(user);
    } on ServerFailure catch (e) {  // ← capturá la variable
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, Stats>> getStats(int id) async {
    try {
      final Stats stats = await userRemoteDatasource.getStats(id.toString());
      return Right(stats);
    } on ServerFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> login(String email, String password) async {
    try {
      final bool resp = await userRemoteDatasource.login(email, password);
      return Right(resp);
    } on ServerFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> register(String email, String password) async {
    try {
      final bool resp = await userRemoteDatasource.register(email, password);
      return Right(resp);
    } on ServerFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final bool resp = await userRemoteDatasource.logout();
      return Right(resp);
    } on ServerFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> update(
    String name,
    String nameTag,
    DateTime fechaNacimiento,
    String? profilePictureUrl,
  ) async {
    try {
      final bool resp = await userRemoteDatasource.update(
        name,
        nameTag,
        fechaNacimiento,
        profilePictureUrl,
      );
      return Right(resp);
    } on ServerFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<ScoreLeaderboardModel>>> getLeaderboard() async {
    try {
      final List<ScoreLeaderboardModel> players =
          await userRemoteDatasource.getLeaderboard();
      return Right(players);
    } on ServerFailure catch (e) {
      return Left(e);
    }
  }
}