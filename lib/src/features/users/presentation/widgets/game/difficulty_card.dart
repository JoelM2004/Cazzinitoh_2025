import 'package:flutter/material.dart';

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

    // Pulse animation for recommended card background
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

    // Badge animation
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

  @override
  Widget build(BuildContext context) {
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
            // Main Card
            AnimatedScale(
              scale: _isPressed
                  ? 0.98
                  : _isHovering
                  ? 1.05
                  : 1.0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 200, // 👈 ancho fijo
                height: 280, // 👈 alto fijo
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: widget.isSelected
                        ? const Color(0xFFA855F7)
                        : widget.option.recommended
                        ? const Color(0xFF7C3AED).withOpacity(0.3)
                        : const Color(0xFF7C3AED).withOpacity(0.3),
                    width: 2,
                  ),
                  color: widget.isSelected
                      ? const Color(0xFF581C87).withOpacity(0.3)
                      : const Color(0xFF1F2937).withOpacity(0.4),
                  boxShadow: [
                    if (widget.isSelected)
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withOpacity(0.3),
                        blurRadius: 16,
                        spreadRadius: 0,
                      ),
                    if (widget.option.recommended)
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withOpacity(0.4),
                        blurRadius: 24,
                        spreadRadius: 0,
                      ),
                    if (_isHovering && !widget.isSelected)
                      BoxShadow(
                        color: const Color(0xFF9333EA).withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 0,
                      ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Animated background for recommended
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
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      const Color(0xFF7C3AED).withOpacity(0.2),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                    // Ring for recommended
                    if (widget.option.recommended)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFA855F7).withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                        ),
                      ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.option.icon,
                            style: const TextStyle(fontSize: 48),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.option.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.option.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFD1D5DB),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Selection indicator
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
                                decoration: const BoxDecoration(
                                  color: Color(0xFF8B5CF6),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
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
            ),

            // Recommended Badge
            if (widget.option.recommended)
              Positioned(
                top: -8,
                right: -8,
                child: AnimatedBuilder(
                  animation: _badgeController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _badgeRotation.value,
                      child: Transform.scale(
                        scale: _badgeScale.value,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFA855F7),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8B5CF6).withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: const Text(
                            'Recomendado',
                            style: TextStyle(
                              fontSize: 12,
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
