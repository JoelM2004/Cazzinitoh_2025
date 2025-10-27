import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularProgress extends StatelessWidget {
  final int percentage;
  final String title;
  final Color color;
  final double size;

  const CircularProgress({
    super.key,
    required this.percentage,
    required this.title,
    this.color = const Color(0xFFA855F7),
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: CircularProgressPainter(
              percentage: percentage,
              color: color,
            ),
            child: Center(
              child: Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 120,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Color(0xFFE5E7EB)),
          ),
        ),
      ],
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final int percentage;
  final Color color;

  CircularProgressPainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.25;
    final strokeWidth = size.width * 0.15;

    // Background circle
    final backgroundPaint = Paint()
      ..color = const Color(0xFF374151)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2; // Start from top
    final sweepAngle = 2 * math.pi * (percentage / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.color != color;
  }
}
