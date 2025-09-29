import 'package:cazzinitoh_2025/src/core/session/session.dart';

import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/game/difficulty_card.dart';
import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _DifficultySelectorState();
}

class _DifficultySelectorState extends State<GamePage>
    with TickerProviderStateMixin {
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
    print("La edad es: ${age}");

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

    // Header animation
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );

    _headerOffset =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
        );

    // Button animation
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _buttonOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
    );

    _buttonOffset = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _buttonController, curve: Curves.easeOut),
        );

    // Start animations
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _buttonController.forward();
      }
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    print('Dificultad seleccionada: $_selectedDifficulty');
    // Aquí iría la lógica para iniciar el juego
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF000000), // black
              Color(0xFF111827), // gray-900
              Color(0xFF581C87), // purple-900
            ],
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            _buildDecorativeCircles(),

            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 672,
                    ), // max-w-2xl

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Back Button
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),

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
                                      shaderCallback: (bounds) {
                                        return const LinearGradient(
                                          colors: [
                                            Colors.white,
                                            Color(0xFFD8B4FE), // purple-300
                                          ],
                                        ).createShader(bounds);
                                      },
                                      child: const Text(
                                        'Memory Trip',
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Elige tu nivel de desafío y adéntrate en el misterio',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFFD1D5DB),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 48),

                        // Difficulty Cards
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isDesktop = constraints.maxWidth > 768;

                            if (isDesktop) {
                              return Row(
                                children: List.generate(
                                  _difficultyOptions.length,
                                  (index) {
                                    return Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right:
                                              index <
                                                  _difficultyOptions.length - 1
                                              ? 24
                                              : 0,
                                        ),
                                        child: _buildDifficultyCard(index),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return Column(
                                children: List.generate(
                                  _difficultyOptions.length,
                                  (index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            index <
                                                _difficultyOptions.length - 1
                                            ? 24
                                            : 0,
                                      ),
                                      child: _buildDifficultyCard(index),
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 40),

                        // Confirm Button
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
      duration: Duration(milliseconds: 600 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: DifficultyCard(
              option: _difficultyOptions[index],
              isSelected: _selectedDifficulty == _difficultyOptions[index].id,
              onTap: () {
                setState(() {
                  _selectedDifficulty = _difficultyOptions[index].id;
                });
              },
              animationDelay: index * 100,
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfirmButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _handleConfirm,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 200),
          tween: Tween(begin: 1.0, end: 1.0),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF8B5CF6).withOpacity(0.5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withOpacity(0.3),
                      blurRadius: 16,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.shield, size: 20, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Iniciar Desafío',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDecorativeCircles() {
    return Stack(
      children: [
        // Top-left circle
        Positioned(top: 40, left: 40, child: _buildPulsingCircle(80, 0)),
        // Bottom-right circle
        Positioned(bottom: 40, right: 40, child: _buildPulsingCircle(64, 1000)),
        // Middle-left circle
        Positioned(
          top: MediaQuery.of(context).size.height / 2,
          left: 20,
          child: _buildPulsingCircle(48, 500),
        ),
      ],
    );
  }

  Widget _buildPulsingCircle(double size, int delay) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 2000),
      tween: Tween(begin: 0.6, end: 1.0),
      curve: Curves.easeInOut,
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
                color: delay == 0
                    ? const Color(0xFF8B5CF6).withOpacity(0.2)
                    : delay == 500
                    ? const Color(0xFF7C3AED).withOpacity(0.2)
                    : const Color(0xFFA855F7).withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
        );
      },
      onEnd: () {
        // Loop animation
        setState(() {});
      },
    );
  }
}
