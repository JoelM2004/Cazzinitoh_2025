import 'package:flutter/material.dart';

class GameStats extends StatelessWidget {
  final int score;
  final int completedPoints;
  final int totalPoints;
  final String timeElapsed;

  const GameStats({
    super.key,
    required this.score,
    required this.completedPoints,
    required this.totalPoints,
    required this.timeElapsed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade900.withOpacity(0.95),
            Colors.purple.shade900.withOpacity(0.95),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: Colors.purple.shade500.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatItem(
              icon: Icons.emoji_events,
              value: score.toString(),
              label: 'Puntos',
              colors: [Colors.yellow.shade400, Colors.orange.shade500],
              delay: 100,
            ),
            _buildStatItem(
              icon: Icons.flag,
              value: '$completedPoints/$totalPoints',
              label: 'Objetivos',
              colors: [Colors.purple.shade400, Colors.deepPurple.shade500],
              delay: 200,
            ),
            _buildStatItem(
              icon: Icons.timer,
              value: timeElapsed,
              label: 'Tiempo',
              colors: [Colors.blue.shade400, Colors.blue.shade600],
              delay: 300,
              isMono: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required List<Color> colors,
    required int delay,
    bool isMono = false,
  }) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - opacity)),
            child: child,
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: isMono ? 'monospace' : null,
                ),
              ),
              Text(
                label,
                style: TextStyle(color: Colors.purple.shade300, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
