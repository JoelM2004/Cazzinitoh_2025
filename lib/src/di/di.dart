import 'package:cazzinitoh_2025/src/di/game_di.dart';
import 'package:cazzinitoh_2025/src/di/location_di.dart';
import 'package:cazzinitoh_2025/src/di/user_di.dart';
import 'package:get_it/get_it.dart';

final di = GetIt.instance;

Future<void> init() async {
  registerLocationDependencies(di);
  registerUserDependencies(di);
  registerGameDependencies(di); // va después de location
} 