import 'package:geolocator/geolocator.dart';

class LocationPermissionHandler {
  /// Verifica y solicita permisos. Retorna true si están concedidos.
  Future<bool> requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  /// Abre la configuración del sistema para habilitar ubicación
  Future<void> openSettings() => Geolocator.openLocationSettings();
}