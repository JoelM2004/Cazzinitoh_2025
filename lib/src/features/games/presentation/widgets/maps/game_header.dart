import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:flutter/material.dart';

class GameHeader extends StatelessWidget {
  final VoidCallback onMenuClick;
  final VoidCallback onSettingsClick;

  const GameHeader({
    super.key,
    required this.onMenuClick,
    required this.onSettingsClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.purple900,
            AppColors.purpleBackground,
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.purpleGlow.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.purple400,
                        AppColors.purple600,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Memory Trip',
                      style: AppTextStyles.h3.copyWith(color: Colors.white),
                    ),
                    Text(
                      'Explora y recuerda',
                      style: AppTextStyles.p.copyWith(
                        color: AppColors.purple300,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.purple900.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: AppColors.purple300,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        TimeOfDay.now().format(context),
                        style: AppTextStyles.p.copyWith(
                          color: AppColors.purple300,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildIconButton(icon: Icons.settings, onTap: onSettingsClick),
                const SizedBox(width: 8),
                _buildIconButton(icon: Icons.menu, onTap: onMenuClick),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.purple300, size: 24),
        ),
      ),
    );
  }
}