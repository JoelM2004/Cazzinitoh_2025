import 'package:flutter/material.dart';
import 'dart:math' as math;

class DestinationMarkerWidget extends StatefulWidget {
  final int order;
  final String title;
  final int timeRemaining;
  final int totalTime;
  final bool isActive;
  final bool isCompleted;
  final String? imageUrl;
  final VoidCallback onTap;

  const DestinationMarkerWidget({
    super.key,
    required this.order,
    required this.title,
    required this.timeRemaining,
    required this.totalTime,
    required this.isActive,
    required this.isCompleted,
    this.imageUrl,
    required this.onTap,
  });

  @override
  State<DestinationMarkerWidget> createState() =>
      _DestinationMarkerWidgetState();
}

class _DestinationMarkerWidgetState extends State<DestinationMarkerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Color _getMarkerColor() {
    if (widget.isCompleted) return Colors.green.shade400;
    if (widget.isActive) return Colors.purple.shade400;
    return Colors.grey.shade400;
  }

  Color _getBorderColor() {
    if (widget.isCompleted) return Colors.green.shade300;
    if (widget.isActive) return Colors.purple.shade300;
    return Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    final minutes = widget.timeRemaining ~/ 60;
    final seconds = widget.timeRemaining % 60;
    final progressPercentage = widget.totalTime > 0
        ? ((widget.totalTime - widget.timeRemaining) / widget.totalTime)
        : 0.0;

    // Para arreglar lo del overflow, porque no lo encontraba
    return LayoutBuilder(
      builder: (context, constraints) {
        final availWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 140.0;
        final isCompact = availWidth < 160.0;

        const circleSize = 72.0;
        const gap = 8.0;
        final infoMaxWidth = isCompact ? 120.0 : 140.0;

        return GestureDetector(
          onTap: widget.onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Glow effect para punto activo
                  if (widget.isActive)
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final scale = 1.0 + (_pulseController.value * 0.25);
                        final opacity = (0.28 - (_pulseController.value * 0.18))
                            .clamp(0.0, 0.28);
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: circleSize,
                            height: circleSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purple.shade500.withOpacity(
                                opacity,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  // Marcador principal
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getMarkerColor(),
                          _getMarkerColor().withOpacity(0.75),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: _getBorderColor(), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.28),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: widget.isCompleted
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 32,
                            )
                          : widget.imageUrl != null
                          ? Image.asset(
                              widget.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildDefaultContent(circleSize),
                            )
                          : _buildDefaultContent(circleSize),
                    ),
                  ),

                  // Barra de progreso circular
                  if (widget.isActive && !widget.isCompleted)
                    SizedBox(
                      width: circleSize,
                      height: circleSize,
                      child: CustomPaint(
                        painter: CircularProgressPainter(
                          progress: progressPercentage.clamp(0.0, 1.0),
                          color: Colors.purple.shade400,
                        ),
                      ),
                    ),
                ],
              ),

              SizedBox(height: gap),

              if (!isCompact)
                // Información del punto
                Container(
                  constraints: BoxConstraints(maxWidth: infoMaxWidth),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.purple.shade500.withOpacity(0.28),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.isActive && !widget.isCompleted) ...[
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer,
                              color: Colors.purple.shade300,
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '$minutes:${seconds.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                color: Colors.purple.shade300,
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (widget.isCompleted)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            '¡Completado!',
                            style: TextStyle(
                              color: Colors.green.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      if (!widget.isActive && !widget.isCompleted)
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'Punto ${widget.order}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDefaultContent(double circleSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.location_on, color: Colors.white, size: 24),
        Text(
          '${widget.order}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircularProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    // Círculo de fondo
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Círculo de progreso
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
