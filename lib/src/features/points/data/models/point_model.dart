import 'package:cazzinitoh_2025/src/features/points/domain/entities/point.dart';

class PointModel extends Point {
  PointModel({
    required super.id,
    required super.name,
    required super.description,
    required super.audio,
    required super.imageUrls,
    required super.coords,
    required super.address,
  });

  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      audio: json['audio'],
      imageUrls: json['imageUrls'],
      coords: json['coords'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'audio': audio,
      'imageUrls': imageUrls,
      'coords': coords,
      'address': address,
    };
  }

  factory PointModel.fromEntity(Point point) {
    return PointModel(
      id: point.id,
      name: point.name,
      description: point.description,
      audio: point.audio,
      imageUrls: point.imageUrls,
      coords: point.coords,
      address: point.address,
    );
  }
}
