import 'package:flutter/material.dart';

enum GameMenuButtonVariant { primary, secondary }

class GameMenuButton extends StatefulWidget {
  final Widget icon;
  final String title;
  final String description;
  final VoidCallback onTap;
  final GameMenuButtonVariant variant;

  const GameMenuButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
    this.variant = GameMenuButtonVariant.secondary,
  }) : super(key: key);

  @override
  State<GameMenuButton> createState() => _GameMenuButtonState();
}

class _GameMenuButtonState extends State<GameMenuButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _indicatorHeightAnimation;
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _iconScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _indicatorHeightAnimation = Tween<double>(begin: 32.0, end: 48.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _isPrimary => widget.variant == GameMenuButtonVariant.primary;

  void _onHoverChange(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
    if (hovering) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _isPressed ? 0.98 : _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _onHoverChange(true),
            onExit: (_) => _onHoverChange(false),
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: Focus(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isPrimary
                          ? const Color(0xFF8B5CF6)
                          : _isHovering
                          ? const Color(0xFF8B5CF6).withOpacity(0.7)
                          : const Color(0xFF475569),
                      width: 2,
                    ),
                    gradient: _isPrimary
                        ? LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: _isHovering
                                ? [
                                    const Color(0xFF8B5CF6),
                                    const Color(0xFF7C3AED),
                                  ]
                                : [
                                    const Color(0xFF7C3AED),
                                    const Color(0xFF6D28D9),
                                  ],
                          )
                        : null,
                    color: _isPrimary
                        ? null
                        : _isHovering
                        ? const Color(0xFF1E293B).withOpacity(0.8)
                        : const Color(0xFF1E293B).withOpacity(0.6),
                    boxShadow: _isPrimary
                        ? [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withOpacity(0.3),
                              blurRadius: 16,
                              spreadRadius: 0,
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    children: [
                      // Efecto de brillo
                      Positioned.fill(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _isHovering ? (_isPrimary ? 0.3 : 0.2) : 0.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.transparent,
                                  Colors.white,
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Contenido principal
                      Row(
                        children: [
                          // Icono
                          Transform.scale(
                            scale: _iconScaleAnimation.value,
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: _isPrimary
                                    ? Colors.white.withOpacity(0.2)
                                    : _isHovering
                                    ? const Color(0xFF8B5CF6).withOpacity(0.3)
                                    : const Color(0xFF8B5CF6).withOpacity(0.2),
                              ),
                              child: Center(
                                child: IconTheme(
                                  data: IconThemeData(
                                    color: _isPrimary
                                        ? Colors.white
                                        : _isHovering
                                        ? const Color(0xFFD8B4FE)
                                        : const Color(0xFFA855F7),
                                    size: 32,
                                  ),
                                  child: widget.icon,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Contenido
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: _isPrimary
                                        ? Colors.white
                                        : _isHovering
                                        ? const Color(0xFFE9D5FF)
                                        : Colors.white,
                                  ),
                                  child: Text(widget.title),
                                ),
                                const SizedBox(height: 4),
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _isPrimary
                                        ? const Color(0xFFE9D5FF)
                                        : _isHovering
                                        ? const Color(0xFFD8B4FE)
                                        : const Color(0xFF94A3B8),
                                  ),
                                  child: Text(widget.description),
                                ),
                              ],
                            ),
                          ),
                          // Indicador de acción
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 8,
                            height: _indicatorHeightAnimation.value,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: _isPrimary
                                  ? Colors.white.withOpacity(0.4)
                                  : _isHovering
                                  ? const Color(0xFFA855F7)
                                  : const Color(0xFF8B5CF6).withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
