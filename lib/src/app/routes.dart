import 'package:cazzinitoh_2025/src/features/games/presentation/pages/quiz_page.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/pages/stats_page.dart';
import 'package:cazzinitoh_2025/src/features/points/presentation/pages/points_page.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/pages/game_page.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/pages/help_page.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/pages/home_page.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/pages/menu_page.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/pages/profile_page.dart';

import 'package:flutter/material.dart';

class AppRoutes {
  static const quiz = '/quiz';
  static const stats = '/stats';
  static const home = '/';
  static const menu = '/menu';
  static const profile = '/profile';
  static const leaderboard = '/leaderboard';
  static const game = '/game';
  static const help = '/help';
  static const points = '/points';
  static const maps = '/maps';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    menu: (context) => const MenuPage(),
    profile: (context) => const ProfilePage(),
    stats: (context) => const StatsPage(),
    help: (context) => const HelpPage(),
    game: (context) => const GamePage(),
    points: (context) => const DestinationSelectorScreen(),
    quiz: (context) => const QuizPage(),
  };
}
