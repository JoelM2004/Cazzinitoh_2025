import 'package:latlong2/latlong.dart';

class Point {
  final int id;
  final String name;
  final String description;
  final String audio;
  final List<String> imageUrls;
  final String address;
  final LatLng coords;
  int timeRemaining;
  final int totalTime;
  bool isActive;
  bool isCompleted;

  Point({
    required this.id,
    required this.name,
    required this.description,
    required this.audio,
    required this.imageUrls,
    required this.address,
    required this.coords,
    this.timeRemaining = 60,
    this.totalTime = 60,
    this.isActive = false,
    this.isCompleted = false,
  });

  Point copyWith({
    int? id,
    String? name,
    String? description,
    String? audio,
    List<String>? imageUrls,
    String? address,
    LatLng? coords,
    int? timeRemaining,
    int? totalTime,
    bool? isActive,
    bool? isCompleted,
  }) {
    return Point(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      audio: audio ?? this.audio,
      imageUrls: imageUrls ?? this.imageUrls,
      address: address ?? this.address,
      coords: coords ?? this.coords,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      totalTime: totalTime ?? this.totalTime,
      isActive: isActive ?? this.isActive,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
