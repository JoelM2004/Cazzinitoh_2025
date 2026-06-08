import 'package:cazzinitoh_2025/src/core/location/location_permission_handler.dart';
import 'package:cazzinitoh_2025/src/core/location/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationServiceImpl implements LocationService {
  final LocationPermissionHandler _permissionHandler;

  LocationServiceImpl(this._permissionHandler);

  static const _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 10, // metros mínimos para emitir nueva posición
  );

  @override
  Stream<LatLng> get positionStream async* {
    final granted = await _permissionHandler.requestPermission();
    if (!granted) return;

    yield* Geolocator.getPositionStream(locationSettings: _locationSettings)
        .map((pos) => LatLng(pos.latitude, pos.longitude));
  }

  @override
  Future<LatLng> getCurrentPosition() async {
    final granted = await _permissionHandler.requestPermission();
    if (!granted) {
      throw Exception('Permisos de ubicación denegados');
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: _locationSettings,
    );

    return LatLng(position.latitude, position.longitude);
  }

  @override
  Future<bool> isLocationEnabled() => Geolocator.isLocationServiceEnabled();
}