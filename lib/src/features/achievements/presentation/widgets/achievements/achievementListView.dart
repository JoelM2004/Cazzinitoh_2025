import 'package:flutter/material.dart';
import 'package:cazzinitoh_2025/src/features/achievements/domain/entities/achievement.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/user.dart';
import 'package:cazzinitoh_2025/src/core/achievements/achievements.dart';

class AchievementsListView extends StatelessWidget {
  final User user;
  final AchievementSrc achievementSrc;

  const AchievementsListView({
    Key? key,
    required this.user,
    required this.achievementSrc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //convertir la lista de ids a Set
    final Set<int> userAchievementIds = user.getIdAchievements().toSet();

    final List<Achievement> all = achievementSrc.achievementsList();

    return ListView.builder(
      itemCount: all.length,
      itemBuilder: (context, index) {
        final ach = all[index];
        final bool owned = userAchievementIds.contains(ach.id);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: owned
                            ? Image.asset(
                                ach.pictureUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _imageErrorPlaceholder();
                                },
                              )
                            : Image.asset(
                                ach.pictureUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                color: Colors.black.withOpacity(0.45),
                                colorBlendMode: BlendMode.darken,
                                errorBuilder: (context, error, stackTrace) {
                                  return _imageErrorPlaceholder();
                                },
                              ),
                      ),

                      //Si NO tiene el logro
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

                //nombre y descripción
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ach.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: owned ? Colors.black : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ach.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: owned ? Colors.black87 : Colors.black45,
                        ),
                      ),

                      //estado
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            owned ? Icons.check_circle : Icons.lock,
                            size: 16,
                            color: owned ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            owned ? 'Obtenido' : 'Bloqueado',
                            style: TextStyle(
                              fontSize: 12,
                              color: owned ? Colors.green : Colors.grey,
                            ),
                          ),
                        ],
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

  //por si falla la imagen
  Widget _imageErrorPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      color: const Color(0xFF374151),
      child: const Icon(Icons.broken_image, size: 32, color: Color(0xFF6B7280)),
    );
  }
}
