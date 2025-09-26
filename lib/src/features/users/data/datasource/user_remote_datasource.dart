import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/stats_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRemoteDatasource {
  Future<UserModel> getUser(int userId);
  Future<StatsModel> getStats(int userId);
  Future<bool> login(String email, String password);
  Future<bool> register(String email, String password);
  Future<bool> logout();
}

class UserRemoteDataSourceImpl implements UserRemoteDatasource {
  final Dio dio = Dio();
  final FirebaseAuth _auth = FirebaseAuth.instance;
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

  // LOGIN
  Future<bool> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Login successful for user desde el back: $email');
      return true;
    } on FirebaseAuthException catch (e) {
      print('Login failed for user desde el back: $email');
      return false;
    }
  }

  // REGISTER
  Future<bool> register(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      throw Exception('Register failed: ${e.message}');
    }
  }

  // LOGOUT
  Future<bool> logout() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
