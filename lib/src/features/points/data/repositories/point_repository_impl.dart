import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/points/data/datasource/point_local_datasource.dart';
import 'package:cazzinitoh_2025/src/features/points/data/datasource/point_remote_datasource.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/repositories/point_repository.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/user.dart';

import 'package:dartz/dartz.dart';

class PointRepositoryImpl implements PointRepository {
  final PointLocalDataSource pointLocalDataSource;
  final PointRemoteDatasource pointRemoteDatasource;

  PointRepositoryImpl({
    required this.pointLocalDataSource,
    required this.pointRemoteDatasource,
  });

  @override
  Future<Either<Failure, bool>> cacheUser(User user) async {
    try {
      final resp = await pointLocalDataSource.cacheUser(user as Point);
      return Right(resp);
    } on LocalFailure {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> getStats(int id) {
    // TODO: implement getStats
    throw UnimplementedError();
  }
}
