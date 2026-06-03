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

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      itemCount: all.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final ach = all[index];
        final owned = userAchievementIds.contains(ach.id);
        return _AchievementTile(ach: ach, owned: owned);
      },
    );
  }
}

class _AchievementTile extends StatelessWidget {
  final Achievement ach;
  final bool owned;

  const _AchievementTile({required this.ach, required this.owned});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: owned
            ? AppColors.purplePrimary.withOpacity(0.12)
            : AppColors.purpleBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: owned
              ? AppColors.purpleBorder.withOpacity(0.55)
              : AppColors.purpleCardBorder.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Badge imagen ──────────────────────────────────────
            _AchievementBadge(ach: ach, owned: owned),
            const SizedBox(width: 14),

            // ── Contenido ──────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          ach.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: owned ? Colors.white : Colors.white38,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                      _StatusBadge(owned: owned),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ach.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: owned
                          ? AppColors.purpleAccent.withOpacity(0.85)
                          : Colors.white24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _RequisitoChip(requisito: ach.requisito, owned: owned),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final Achievement ach;
  final bool owned;

  const _AchievementBadge({required this.ach, required this.owned});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 68,
      height: 68,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Anillo exterior
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: owned
                    ? AppColors.purpleAccent.withOpacity(0.6)
                    : Colors.white12,
                width: 2,
              ),
            ),
          ),

          // Imagen
          Padding(
            padding: const EdgeInsets.all(4),
            child: ClipOval(
              child: ColorFiltered(
                colorFilter: owned
                    ? const ColorFilter.mode(Colors.transparent, BlendMode.multiply)
                    : const ColorFilter.matrix([
                        0.2, 0, 0, 0, 0,
                        0, 0.2, 0, 0, 0,
                        0, 0, 0.2, 0, 0,
                        0, 0, 0, 1, 0,
                      ]),
                child: Image.asset(
                  ach.pictureUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.purple900,
                    child: const Icon(Icons.military_tech, size: 32, color: AppColors.purpleAccent),
                  ),
                ),
              ),
            ),
          ),

          // Candado si no tiene el logro
          if (!owned)
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_rounded, size: 20, color: Colors.white54),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool owned;

  const _StatusBadge({required this.owned});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: owned
            ? AppColors.purplePrimary.withOpacity(0.35)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: owned
              ? AppColors.purpleAccent.withOpacity(0.5)
              : Colors.white12,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            owned ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
            size: 11,
            color: owned ? AppColors.purpleAccent : Colors.white30,
          ),
          const SizedBox(width: 4),
          Text(
            owned ? 'Obtenido' : 'Bloqueado',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: owned ? AppColors.purpleAccent : Colors.white30,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequisitoChip extends StatelessWidget {
  final String requisito;
  final bool owned;

  const _RequisitoChip({required this.requisito, required this.owned});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.flag_rounded,
          size: 12,
          color: owned
              ? AppColors.purpleAccent.withOpacity(0.5)
              : Colors.white,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            requisito,
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: owned
                  ? AppColors.purpleAccent.withOpacity(0.55)
                  : Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}