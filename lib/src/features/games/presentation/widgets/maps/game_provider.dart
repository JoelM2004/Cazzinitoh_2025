// import 'dart:async';
// import 'package:cazzinitoh_2025/src/core/points/points.dart';
// import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';
// import 'package:flutter/material.dart';
// import 'package:latlong2/latlong.dart';

// enum GamePhase {
//   waiting,      // cartelito inicial, antes de empezar
//   memorizing,   // 60s viendo los puntos
//   playing,      // jugando
//   finished,     // terminó
// }

// class GameProvider with ChangeNotifier {
//   int _score = 0;
//   int _gameTime = 0;
//   int _memorizingSecondsLeft = 60;
//   double _zoom = 15.0;
//   Timer? _gameTimer;
//   Timer? _memorizingTimer;
//   GamePhase _phase = GamePhase.waiting;

//   final LatLng _currentLocation = const LatLng(-46.4406, -67.5256);

//   late List<Point> _points;
//   int? _selectedPointId;

//   // ── Getters ──────────────────────────────────────────────────

//   int get score => _score;
//   int get gameTime => _gameTime;
//   int get memorizingSecondsLeft => _memorizingSecondsLeft;
//   double get zoom => _zoom;
//   LatLng get currentLocation => _currentLocation;
//   List<Point> get points => _points;
//   GamePhase get phase => _phase;
//   int? get selectedPointId => _selectedPointId;

//   int get completedCount => _points.where((p) => p.isCompleted).length;
//   int get totalCount => _points.length;
//   bool get allCompleted => completedCount == totalCount;

//   GameProvider() {
//     _initializePoints();
//   }

//   void _initializePoints() {
//     _points = PointsSrc.points.map((point) {
//       return point.copyWith(
//         timeRemaining: 60,
//         totalTime: 60,
//         isActive: false,
//         isCompleted: false,
//       );
//     }).toList();
//   }

//   // ── Fase 1: usuario toca "Comenzar" ──────────────────────────

//   void startMemorizing() {
//     _phase = GamePhase.memorizing;
//     _memorizingSecondsLeft = 60;
//     notifyListeners();

//     _memorizingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       _memorizingSecondsLeft--;
//       notifyListeners();

//       if (_memorizingSecondsLeft <= 0) {
//         timer.cancel();
//         _startPlaying();
//       }
//     });
//   }

//   // ── Fase 2: arrancar el juego real ───────────────────────────

//   void _startPlaying() {
//     _phase = GamePhase.playing;
//     notifyListeners();

//     _gameTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       _gameTime++;
//       notifyListeners();
//     });
//   }

//   // ── Seleccionar un punto (el jugador lo elige) ───────────────

//   void selectPoint(int id) {
//     if (_phase != GamePhase.playing) return;
//     final point = _points.firstWhere((p) => p.id == id, orElse: () => _points.first);
//     if (point.isCompleted) return;

//     // Desactivar el anterior
//     _points = _points.map((p) {
//       if (p.isActive && p.id != id) return p.copyWith(isActive: false);
//       if (p.id == id) return p.copyWith(isActive: true);
//       return p;
//     }).toList();

//     _selectedPointId = id;
//     notifyListeners();
//   }

//   // ── Marcar punto como completado (después del quiz) ──────────

//   void completePoint(int id, {bool correct = true}) {
//     final index = _points.indexWhere((p) => p.id == id);
//     if (index == -1) return;

//     if (correct) {
//       _score += 500;
//       _points[index] = _points[index].copyWith(isCompleted: true, isActive: false);
//     } else {
//       _score = (_score - 50).clamp(0, 999999);
//     }

//     _selectedPointId = null;

//     if (allCompleted) {
//       _gameTimer?.cancel();
//       _phase = GamePhase.finished;
//     }

//     notifyListeners();
//   }

//   // ── Zoom ─────────────────────────────────────────────────────

//   void zoomIn() {
//     _zoom = (_zoom + 1.0).clamp(12.0, 18.0);
//     notifyListeners();
//   }

//   void zoomOut() {
//     _zoom = (_zoom - 1.0).clamp(12.0, 18.0);
//     notifyListeners();
//   }

//   String formatGameTime() {
//     final minutes = _gameTime ~/ 60;
//     final seconds = _gameTime % 60;
//     return '$minutes:${seconds.toString().padLeft(2, '0')}';
//   }

//   @override
//   void dispose() {
//     _gameTimer?.cancel();
//     _memorizingTimer?.cancel();
//     super.dispose();
//   }
// }