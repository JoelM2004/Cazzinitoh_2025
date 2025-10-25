import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:cazzinitoh_2025/src/core/achievements/achievements.dart';
import 'package:cazzinitoh_2025/src/features/achievements/domain/entities/achievement.dart';

class AchievementsListViewByIds extends StatelessWidget {
  final Set<int> userAchievementIds;
  final AchievementSrc achievementSrc;

  const AchievementsListViewByIds({
    Key? key,
    required this.userAchievementIds,
    required this.achievementSrc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Achievement> all = achievementSrc.achievementsList();

    return ListView.builder(
      itemCount: all.length,
      itemBuilder: (context, index) {
        final ach = all[index];
        final owned = userAchievementIds.contains(ach.id);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          ach.pictureUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          color: owned ? null : Colors.black.withOpacity(0.45),
                          colorBlendMode: owned ? null : BlendMode.darken,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: const Color(0xFF374151),
                              child: const Icon(
                                Icons.broken_image,
                                size: 32,
                                color: Color(0xFF6B7280),
                              ),
                            );
                          },
                        ),
                      ),
                      if (!owned)
                        Image.asset(
                          'assets/images/achievements/candado.png',
                          width: 48,
                          height: 48,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ach.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: owned
                              ? AppColors.switchBackground
                              : AppColors.destructive,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ach.description,
                        style: TextStyle(
                          color: owned ? Color(0xFFD8B4FE) : Color(0xFFD8B4FE),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Requisito: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: owned
                              ? AppColors.switchBackground
                              : AppColors.destructive,
                        ),
                      ),
                      Text(
                        ach.requisito,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                          color: owned ? Color(0xFFB794F4) : Color(0xFFD8B4FE),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
