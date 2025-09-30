import 'package:google_maps_flutter/google_maps_flutter.dart';

class Point {
  final int id;
  final String name;
  final String description;
  final String audio;
  final List<String> imageUrls;
  final LatLng coords;

  Point({
    required this.id,
    required this.name,
    required this.description,
    required this.audio,
    required this.imageUrls,
    required this.coords,
  });
}
