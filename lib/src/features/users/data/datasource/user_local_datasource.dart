import 'package:cazzinitoh_2025/src/core/error/failures.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class UserLocalDataSource {
  Future<bool> cacheUser(User user);
}

//esto se puede hacer con sql igual, no hay drama

class HiveUserLocalDataSourceImpl implements UserLocalDataSource {
  HiveUserLocalDataSourceImpl() {
    Hive.initFlutter();
  }

  @override
  Future<bool> cacheUser(User user) async {
    try {
      Box<dynamic> box = await Hive.openBox('userBox');

      box.put(user.id, UserModel.fromEntity(user).toJson());

      return true;
    } catch (e) {
      throw LocalFailure();
    }
  }
}
