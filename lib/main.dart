
import 'package:cazzinitoh_2025/src/app/app.dart';
import 'package:cazzinitoh_2025/src/app/providers.dart';
import 'package:cazzinitoh_2025/src/di/di.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(
    AppProviders(child: const MyApp()),
  );
}