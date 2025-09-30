import 'package:cazzinitoh_2025/src/features/points/data/models/point_model.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class PointRemoteDatasource {
  Future<Point> getUser(int userId);
}

class PointRemoteDataSourceImpl implements PointRemoteDatasource {
  final Dio dio = Dio();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //esto es para consultar APIS remotadas, en un futuro o si usamos firebase por ejemplo jeje

  @override
  Future<Point> getUser(int userId) async {
    final response = await dio.get('https://api.example.com/users/$userId');

    if (response.statusCode == 200) {
      return PointModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
