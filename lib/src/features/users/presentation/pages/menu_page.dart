import 'package:cazzinitoh_2025/src/app/routes.dart';
import 'package:cazzinitoh_2025/src/core/session/session.dart';
import 'package:flutter/material.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/menu/game_menu_button.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  void _handleMenuAction(BuildContext context, String action) {
    print('Acción seleccionada: $action');

    switch (action) {
      case 'profile':
        Navigator.pushNamed(context, AppRoutes.profile);
        break;
      case 'game':
        Navigator.pushNamed(context, AppRoutes.game);
        break;
      case 'help':
        Navigator.pushNamed(context, AppRoutes.help);
        break;
      case 'leaderboard':
        // Aquí hacés logout y redirigís al login/home
        //Navigator.pushReplacementNamed(context, AppRoutes.leaderboard);
        //Navigator.pushReplacementNamed(context, AppRoutes.stats);
        Navigator.pushReplacementNamed(context, AppRoutes.quiz);
        break;
      case 'logout':
        // Aquí hacés logout y redirigís al login/home
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      default:
        print('Acción no reconocida');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF581C87), Color(0xFF0F172A)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                Column(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF8B5CF6),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withOpacity(0.3),
                            blurRadius: 32,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFXPjQLqQ1omAaN1fe-qqg_NoDsM7rZ4L9C4TDuuA6zTHu8hGN_PEDH8-WCMc64Nt4gAg&usqp=CAU',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Text(
                      'Memory Trip',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Entra al gran desafío, ${Session.currentUser?.name ?? "Jugador"}!',
                      style: TextStyle(
                        fontSize: 18,
                        color: const Color(0xFFD8B4FE).withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // Menú principal
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      children: [
                        GameMenuButton(
                          icon: const Icon(Icons.play_arrow),
                          title: 'Iniciar Desafío',
                          description: 'Comienza tu aventura',
                          onTap: () => _handleMenuAction(context, 'game'),
                          variant: GameMenuButtonVariant.primary,
                        ),
                        const SizedBox(height: 16),
                        GameMenuButton(
                          icon: const Icon(Icons.person),
                          title: 'Perfil del Jugador',
                          description: 'Configura tu personaje',
                          onTap: () => _handleMenuAction(context, 'profile'),
                          variant: GameMenuButtonVariant.secondary,
                        ),
                        const SizedBox(height: 16),
                        GameMenuButton(
                          icon: const Icon(Icons.emoji_events),
                          title: 'Leaderboard',
                          description: 'Puntuaciones globales',
                          onTap: () =>
                              _handleMenuAction(context, 'leaderboard'),
                          variant: GameMenuButtonVariant.secondary,
                        ),
                        const SizedBox(height: 16),
                        GameMenuButton(
                          icon: const Icon(Icons.help_outline),
                          title: 'Ayuda & Tutorial',
                          description: 'Aprende a jugar',
                          onTap: () => _handleMenuAction(context, 'help'),
                          variant: GameMenuButtonVariant.secondary,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),

                // Footer
                const Text(
                  'Versión 1.0 • © 2025 Memory Trip',
                  style: TextStyle(fontSize: 14, color: Color(0xFFA855F7)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
