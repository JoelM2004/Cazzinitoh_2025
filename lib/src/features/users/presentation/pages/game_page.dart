// lib/src/features/users/presentation/pages/game_page.dart
import 'package:cazzinitoh_2025/src/app/routes.dart';
import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:cazzinitoh_2025/src/core/session/session.dart';
import 'package:cazzinitoh_2025/src/features/shared/widgets/app_alert.dart';
import 'package:cazzinitoh_2025/src/features/shared/widgets/app_back_nav_bar.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/game/difficulty_card.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  Difficulty _selectedDifficulty = Difficulty.medium;

  late final List<DifficultyOption> _difficultyOptions;
  late AnimationController _headerController;
  late AnimationController _buttonController;
  late Animation<double> _headerOpacity;
  late Animation<Offset> _headerOffset;
  late Animation<double> _buttonOpacity;
  late Animation<Offset> _buttonOffset;

  @override
  void initState() {
    super.initState();
    final age = Session.currentUser?.age ?? 0;

    _difficultyOptions = [
      DifficultyOption(
        id: Difficulty.easy,
        icon: '🌿',
        title: 'Fácil',
        description: 'Un sendero tenue para quienes recién comienzan',
        recommended: age >= 65,
      ),
      DifficultyOption(
        id: Difficulty.medium,
        icon: '⚔️',
        title: 'Medio',
        description: 'Pruebas exigentes que retan tu memoria',
        recommended: age > 30 && age < 65,
      ),
      DifficultyOption(
        id: Difficulty.hard,
        icon: '🔥',
        title: 'Difícil',
        description: 'Un viaje intenso donde cada error pesa',
        recommended: age <= 30,
      ),
    ];

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );

    _headerOffset =
        Tween<Offset>(begin: const Offset(0, -0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );

    _buttonOffset =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    // Mostrar info del nivel seleccionado antes de navegar
    final labels = {
      Difficulty.easy: 'Fácil',
      Difficulty.medium: 'Medio',
      Difficulty.hard: 'Difícil',
    };

    AppAlert.show(
      context,
      type: AlertType.info,
      title: 'Iniciando desafío',
      message: 'Nivel ${labels[_selectedDifficulty]} seleccionado. ¡Buena suerte!',
      duration: const Duration(seconds: 2),
    );

    await Future.delayed(const Duration(milliseconds: 600));

    final result = await Navigator.pushNamed(
      context,
      AppRoutes.maps,
      arguments: {'difficulty': _selectedDifficulty},
    );

    if (result != null && mounted) {
      Navigator.pushNamed(
        context,
        AppRoutes.points,
        arguments: {'fromMap': result},
      );
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    extendBodyBehindAppBar: true,
    appBar: AppBackNavBar(title: 'Memory Trip'),  // ← acá
    body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.purpleBackground,
            AppColors.purple900,
            Color(0xFF0d0d1a),
          ],
        ),
      ),
      child: Stack(
        children: [
          _buildDecorativeCircles(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 672),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),

                      // Header
                      AnimatedBuilder(
                        animation: _headerController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _headerOpacity,
                            child: SlideTransition(
                              position: _headerOffset,
                              child: Column(
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
                                      colors: [
                                        Colors.white,
                                        AppColors.purple300,
                                      ],
                                    ).createShader(bounds),
                                    child: const Text(
                                      'Elegí tu desafío',
                                      style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Seleccioná el nivel y adentrate en el misterio',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.purple300.withOpacity(0.8),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 48),

                      // Cards
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isDesktop = constraints.maxWidth > 640;
                          if (isDesktop) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _difficultyOptions.length,
                                (index) => Padding(
                                  padding: EdgeInsets.only(
                                    right: index < _difficultyOptions.length - 1 ? 24 : 0,
                                  ),
                                  child: _buildDifficultyCard(index),
                                ),
                              ),
                            );
                          } else {
                            return Column(
                              children: List.generate(
                                _difficultyOptions.length,
                                (index) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index < _difficultyOptions.length - 1 ? 20 : 0,
                                  ),
                                  child: _buildDifficultyCard(index),
                                ),
                              ),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 40),

                      // Botón confirmar
                      AnimatedBuilder(
                        animation: _buttonController,
                        builder: (context, child) {
                          return FadeTransition(
                            opacity: _buttonOpacity,
                            child: SlideTransition(
                              position: _buttonOffset,
                              child: _buildConfirmButton(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildDifficultyCard(int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (index * 120)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - value)),
            child: DifficultyCard(
              option: _difficultyOptions[index],
              isSelected: _selectedDifficulty == _difficultyOptions[index].id,
              onTap: () => setState(() {
                _selectedDifficulty = _difficultyOptions[index].id;
              }),
              animationDelay: index * 100,
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmButton() {
    return GestureDetector(
      onTap: _handleConfirm,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.purple700, AppColors.purple900],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.purpleBorder.withOpacity(0.6),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.purpleGlow.withOpacity(0.4),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.shield_rounded, size: 20, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'Iniciar Desafío',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildDecorativeCircles() {
  return LayoutBuilder(
    builder: (context, constraints) {
      return Stack(
        children: [
          Positioned(top: 40, left: 40, child: _buildCircle(80, AppColors.purple500, 0)),
          Positioned(bottom: 40, right: 40, child: _buildCircle(64, AppColors.purpleAccent, 1000)),
          Positioned(
            top: constraints.maxHeight / 2,  // ← usa constraints en vez de MediaQuery
            left: 20,
            child: _buildCircle(48, AppColors.purple700, 500),
          ),
        ],
      );
    },
  );
}
  Widget _buildCircle(double size, Color color, int delay) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 2000 + delay),
      tween: Tween(begin: 0.3, end: 0.8),
      curve: Curves.easeInOut,
      onEnd: () => setState(() {}),
      builder: (context, value, child) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 2000 + delay),
          opacity: value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
        );
      },
    );
  }
}