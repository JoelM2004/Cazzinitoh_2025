import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/points/data/models/point_model.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class PointLocalDataSource {
  Future<bool> cacheUser(Point point);
}

//esto se puede hacer con sql igual, no hay drama

class HivePointLocalDataSourceImpl implements PointLocalDataSource {
  HivePointLocalDataSourceImpl() {
    Hive.initFlutter();
  }

  @override
  Future<bool> cacheUser(Point point) async {
    try {
      Box<dynamic> box = await Hive.openBox('pointBox');

      box.put(point.id, PointModel.fromEntity(point).toJson());

      return true;
    } catch (e) {
      throw LocalFailure();
    }
  }
}
