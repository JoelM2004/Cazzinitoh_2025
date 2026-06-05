// lib/src/features/users/presentation/widgets/game/difficulty_card.dart
import 'package:flutter/material.dart';
import 'package:cazzinitoh_2025/src/app/theme.dart';

enum Difficulty { easy, medium, hard }

class DifficultyOption {
  final Difficulty id;
  final String icon;
  final String title;
  final String description;
  final bool recommended;

  DifficultyOption({
    required this.id,
    required this.icon,
    required this.title,
    required this.description,
    this.recommended = false,
  });
}

class DifficultyCard extends StatefulWidget {
  final DifficultyOption option;
  final bool isSelected;
  final VoidCallback onTap;
  final int animationDelay;

  const DifficultyCard({
    Key? key,
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.animationDelay,
  }) : super(key: key);

  @override
  State<DifficultyCard> createState() => _DifficultyCardState();
}

class _DifficultyCardState extends State<DifficultyCard>
    with TickerProviderStateMixin {
  bool _isHovering = false;
  bool _isPressed = false;
  late AnimationController _pulseController;
  late AnimationController _badgeController;
  late Animation<double> _pulseOpacity;
  late Animation<double> _pulseScale;
  late Animation<double> _badgeRotation;
  late Animation<double> _badgeScale;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseOpacity = Tween<double>(begin: 0.1, end: 0.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pulseScale = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _badgeController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _badgeRotation = Tween<double>(begin: -0.035, end: 0.035).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.easeInOut),
    );

    _badgeScale = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  // Color del borde según dificultad
  Color get _difficultyColor {
    switch (widget.option.id) {
      case Difficulty.easy:
        return const Color(0xFF22c55e);   // verde
      case Difficulty.medium:
        return AppColors.purplePrimary;   // purple del theme
      case Difficulty.hard:
        return AppColors.red500;          // rojo del theme
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isSelected
        ? _difficultyColor
        : widget.option.recommended
            ? AppColors.purpleBorder.withOpacity(0.4)
            : AppColors.purpleCardBorder.withOpacity(0.4);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedScale(
              scale: _isPressed ? 0.97 : _isHovering ? 1.04 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 200,
                height: 290,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor, width: 2),
                  color: widget.isSelected
                      ? AppColors.purple900.withOpacity(0.35)
                      : AppColors.purpleCard.withOpacity(0.45),
                  boxShadow: [
                    if (widget.isSelected)
                      BoxShadow(
                        color: _difficultyColor.withOpacity(0.35),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    if (widget.option.recommended && !widget.isSelected)
                      BoxShadow(
                        color: AppColors.purpleGlow.withOpacity(0.3),
                        blurRadius: 24,
                        spreadRadius: 0,
                      ),
                    if (_isHovering && !widget.isSelected)
                      BoxShadow(
                        color: _difficultyColor.withOpacity(0.4),
                        blurRadius: 28,
                        spreadRadius: 0,
                      ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Fondo animado para recommended
                    if (widget.option.recommended)
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _pulseOpacity.value,
                            child: Transform.scale(
                              scale: _pulseScale.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.purple700.withOpacity(0.25),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                    // Ring recomendado
                    if (widget.option.recommended)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.purpleBorder.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                    // Contenido
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Ícono con glow
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _difficultyColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _difficultyColor.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              widget.option.icon,
                              style: const TextStyle(fontSize: 36),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.option.title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: widget.isSelected
                                  ? _difficultyColor
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.option.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.purple300.withOpacity(0.8),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Indicador de selección
                    if (widget.isSelected)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 400),
                          tween: Tween(begin: 0.0, end: 1.0),
                          curve: Curves.elasticOut,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: _difficultyColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Badge recomendado
            if (widget.option.recommended)
              Positioned(
                top: -10,
                right: -10,
                child: AnimatedBuilder(
                  animation: _badgeController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _badgeRotation.value,
                      child: Transform.scale(
                        scale: _badgeScale.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.purplePrimary,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.purpleBorder,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.purpleGlow.withOpacity(0.5),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Text(
                            'Recomendado',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}