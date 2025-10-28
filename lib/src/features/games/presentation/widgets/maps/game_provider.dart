import 'dart:async';
import 'package:cazzinitoh_2025/src/core/points/points.dart';
import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class GameProvider with ChangeNotifier {
  int _score = 1250;
  int _gameTime = 0;
  double _zoom = 15.0;
  Timer? _gameTimer;

  // Coordenadas de Caleta Olivia, Santa Cruz, Argentina (centro de la ciudad)
  final LatLng _currentLocation = const LatLng(-46.4406, -67.5256);

  // Cargar puntos desde PointsSrc
  late List<Point> _points;

  int get score => _score;
  int get gameTime => _gameTime;
  double get zoom => _zoom;
  LatLng get currentLocation => _currentLocation;
  List<Point> get points => _points;

  int get completedCount => _points.where((p) => p.isCompleted).length;
  int get totalCount => _points.length;

  GameProvider() {
    _initializePoints();
    _startGameTimer();
  }

  void _initializePoints() {
    // Copiar los puntos de PointsSrc y añadir propiedades del juego
    _points = PointsSrc.points.map((point) {
      return point.copyWith(
        timeRemaining: 60,
        totalTime: 60,
        isActive: false,
        isCompleted: false,
      );
    }).toList();

    // Activar el primer punto
    if (_points.isNotEmpty) {
      _points[0] = _points[0].copyWith(isActive: true);
    }
  }

  void _startGameTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _gameTime++;

      for (int i = 0; i < _points.length; i++) {
        if (_points[i].isActive &&
            !_points[i].isCompleted &&
            _points[i].timeRemaining > 0) {
          _points[i] = _points[i].copyWith(
            timeRemaining: _points[i].timeRemaining - 1,
          );

          if (_points[i].timeRemaining <= 0) {
            _points[i] = _points[i].copyWith(isActive: false);
          }
        }
      }

      notifyListeners();
    });
  }

  void activatePoint(int id) {
    final index = _points.indexWhere((p) => p.id == id);
    if (index == -1) return;

    final point = _points[index];
    if (point.isCompleted) return;

    if (point.isActive) {
      _score += 500;
    }

    _points[index] = point.copyWith(isCompleted: true, isActive: false);

    // Activar siguiente punto
    if (index + 1 < _points.length) {
      final nextPoint = _points[index + 1];
      if (!nextPoint.isCompleted) {
        _points[index + 1] = nextPoint.copyWith(isActive: true);
      }
    }

    notifyListeners();
  }

  void setZoom(double newZoom) {
    _zoom = newZoom.clamp(12.0, 18.0);
    notifyListeners();
  }

  void zoomIn() {
    setZoom(_zoom + 1.0);
  }

  void zoomOut() {
    setZoom(_zoom - 1.0);
  }

  String formatGameTime() {
    final minutes = _gameTime ~/ 60;
    final seconds = _gameTime % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}
