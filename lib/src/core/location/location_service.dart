import 'package:latlong2/latlong.dart';

abstract class LocationService {
  /// Stream de posición en tiempo real
  Stream<LatLng> get positionStream;

  /// Obtener posición actual una sola vez
  Future<LatLng> getCurrentPosition();

  /// Verificar si el servicio de ubicación está habilitado
  Future<bool> isLocationEnabled();
}