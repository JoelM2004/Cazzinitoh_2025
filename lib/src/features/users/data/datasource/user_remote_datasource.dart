import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/stats_model.dart';
import 'package:dio/dio.dart';

abstract class UserRemoteDatasource {
  Future<UserModel> getUser(int userId);
  Future<StatsModel> getStats(int userId);
  Future<bool> login(String email, String password);
  Future<bool> register(String email, String password);
  Future<bool> logout();
}

class UserRemoteDataSourceImpl implements UserRemoteDatasource {
  final Dio dio = Dio();
  //esto es para consultar APIS remotadas, en un futuro o si usamos firebase por ejemplo jeje
  @override
  Future<UserModel> getUser(int userId) async {
    final response = await dio.get('https://api.example.com/users/$userId');

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<StatsModel> getStats(int userId) async {
    final response = await dio.get(
      'https://api.example.com/users/$userId/stats',
    );

    if (response.statusCode == 200) {
      return StatsModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load stats');
    }
  }

  Future<bool> login(String email, String password) async {
    final response = await dio.post(
      'https://api.example.com/login',
      data: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<bool> register(String email, String password) async {
    final response = await dio.post(
      'https://api.example.com/register',
      data: {'email': email, 'password': password},
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<bool> logout() async {
    final response = await dio.post('https://api.example.com/logout');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to logout');
    }
  }
}
