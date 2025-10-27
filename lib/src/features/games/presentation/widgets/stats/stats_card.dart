import 'package:flutter/material.dart';

enum StatsCardColor { purple, red, gray }

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final StatsCardColor color;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.color = StatsCardColor.purple,
  });

  List<Color> _getGradientColors() {
    switch (color) {
      case StatsCardColor.purple:
        return [const Color(0xCC581C87), const Color(0x996B21A8)];
      case StatsCardColor.red:
        return [const Color(0xCC7F1D1D), const Color(0x99991B1B)];
      case StatsCardColor.gray:
        return [const Color(0xCC1F2937), const Color(0x991F2937)];
    }
  }

  Color _getBorderColor() {
    switch (color) {
      case StatsCardColor.purple:
        return const Color(0x807C3AED);
      case StatsCardColor.red:
        return const Color(0x80B91C1C);
      case StatsCardColor.gray:
        return const Color(0x80374151);
    }
  }

  Color _getIconColor() {
    switch (color) {
      case StatsCardColor.purple:
        return const Color(0xFFC084FC);
      case StatsCardColor.red:
        return const Color(0xFFF87171);
      case StatsCardColor.gray:
        return const Color(0xFF9CA3AF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _getGradientColors(),
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getBorderColor(), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: _getIconColor(), size: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFD1D5DB),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Color(0xFFE5E7EB)),
          ),
        ],
      ),
    );
  }
}
