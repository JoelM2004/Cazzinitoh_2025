import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/home_page/login_widget.dart';
import 'package:flutter/material.dart';

enum Screen { login, map }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  Screen currentScreen = Screen.login;

  void navigateToLogin() {
    setState(() {
      currentScreen = Screen.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Trip',
      home: Scaffold(body: const LoginScreen()),
    );
  }
}
