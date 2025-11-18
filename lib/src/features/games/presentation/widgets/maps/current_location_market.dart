import 'package:flutter/material.dart';

class CurrentLocationMarkerWidget extends StatefulWidget {
  const CurrentLocationMarkerWidget({super.key});

  @override
  State<CurrentLocationMarkerWidget> createState() =>
      _CurrentLocationMarkerWidgetState();
}

class _CurrentLocationMarkerWidgetState
    extends State<CurrentLocationMarkerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Pulso de ubicación
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final scale = 1.0 + (_controller.value * 0.35);
                final opacity = (0.6 - (_controller.value * 0.5)).clamp(
                  0.0,
                  0.6,
                );
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade400.withOpacity(opacity),
                    ),
                  ),
                );
              },
            ),

            // Marcador principal
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 28),
            ),

            // Punto central
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        const SizedBox(height: 6),
        // Etiqueta
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade900.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'Tu ubicación',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
