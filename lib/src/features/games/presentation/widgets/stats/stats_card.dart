import 'package:cazzinitoh_2025/src/app/theme.dart';
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
        return [
          AppColors.purple900.withOpacity(0.8),
          AppColors.purple600.withOpacity(0.6),
        ];
      case StatsCardColor.red:
        return [
          AppColors.red700.withOpacity(0.8),
          AppColors.red700.withOpacity(0.6),
        ];
      case StatsCardColor.gray:
        return [
          AppColors.darkCard.withOpacity(0.8),
          AppColors.darkCard.withOpacity(0.6),
        ];
    }
  }

  Color _getBorderColor() {
    switch (color) {
      case StatsCardColor.purple:
        return AppColors.purpleBorder.withOpacity(0.5);
      case StatsCardColor.red:
        return AppColors.red700.withOpacity(0.5);
      case StatsCardColor.gray:
        return AppColors.darkBorder.withOpacity(0.5);
    }
  }

  Color _getIconColor() {
    switch (color) {
      case StatsCardColor.purple:
        return AppColors.purple400;
      case StatsCardColor.red:
        return AppColors.red400;
      case StatsCardColor.gray:
        return AppColors.darkMutedForeground;
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
                    style: AppTextStyles.h1.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTextStyles.p.copyWith(
                        fontSize: 12,
                        color: AppColors.darkMutedForeground,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyles.p.copyWith(color: AppColors.darkForeground),
          ),
        ],
      ),
    );
  }
}