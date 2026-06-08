import 'package:cazzinitoh_2025/src/core/location/location_permission_handler.dart';
import 'package:cazzinitoh_2025/src/core/location/location_service.dart';
import 'package:cazzinitoh_2025/src/core/location/location_service_impl.dart';
import 'package:get_it/get_it.dart';

void registerLocationDependencies(GetIt di) {
  di.registerLazySingleton(() => LocationPermissionHandler());
  di.registerLazySingleton<LocationService>(
    () => LocationServiceImpl(di()),
  );
}