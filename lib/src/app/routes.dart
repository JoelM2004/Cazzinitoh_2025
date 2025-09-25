import 'package:cazzinitoh_2025/src/features/users/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const home = '/';
  static const settings = '/settings';
  static const contacts = '/contacts';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
  };
}
