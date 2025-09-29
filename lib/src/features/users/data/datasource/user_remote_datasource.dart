import 'package:cazzinitoh_2025/src/core/session/session.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/stats_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Login successful for user: $email');

      // Buscar en Firestore el user
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        Session.currentUser = UserModel.fromJson(data);
        print("Usuario cargado en memoria: ${Session.currentUser!.name}");
      } else {
        print("Usuario no encontrado en Firestore");
      }

      return true;
    } on FirebaseAuthException catch (e) {
      print('Login failed for user: $email -> ${e.message}');
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = credential.user!.uid; // ID único del Auth

      final newUser = UserModel(
        id: userId,
        name: "Nuevo usuario",
        nameTag: "tag_$userId",
        age: 0,
        email: email,
        profilePictureUrl: "",
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(newUser.toJson());

      print("Usuario registrado en Firestore con ID: $userId");

      return true;
    } on FirebaseAuthException catch (e) {
      print('Register failed for user: $email -> ${e.message}');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await _auth.signOut();
      Session.currentUser = null; // Limpiar usuario en memoria
      print("Usuario deslogueado y Session limpia");
      return true;
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
