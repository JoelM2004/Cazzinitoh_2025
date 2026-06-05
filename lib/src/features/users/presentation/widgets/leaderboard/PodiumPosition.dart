import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/leaderboard/ImageWithFallback.dart';
import 'package:flutter/material.dart';

class PodiumPosition extends StatelessWidget {
  final int rank;
  final UserWithScore userWithScore;
  final double height;

  const PodiumPosition({
    super.key,
    required this.rank,
    required this.userWithScore,
    required this.height,
  });

  LinearGradient get _rankGradient {
    switch (rank) {
      case 1:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFBBF24), Color(0xFFCA8A04)],
        );
      case 2:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFD1D5DB), Color(0xFF6B7280)],
        );
      case 3:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFD97706), Color(0xFF92400E)],
        );
      default:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.purpleBorder, AppColors.purplePrimary],
        );
    }
  }

  String get _rankIcon {
    switch (rank) {
      case 1: return '👑';
      case 2: return '🥈';
      case 3: return '🥉';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Avatar ────────────────────────────────────────────────────────
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: userWithScore.isCurrentUser
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.red500, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.red500.withOpacity(0.4),
                          blurRadius: 10,
                        ),
                      ],
                    )
                  : null,
              child: ImageWithFallback(
                imageUrl: userWithScore.avatar,
                width: 64,
                height: 64,
                borderRadius: 32,
                borderWidth: 2,
                borderColor: Colors.white.withOpacity(0.3),
              ),
            ),
            if (rank <= 3)
              Positioned(
                top: -10,
                right: -10,
                child: Text(_rankIcon, style: const TextStyle(fontSize: 22)),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // ── Info jugador ───────────────────────────────────────────────────
        SizedBox(
          width: 84,
          child: Column(
            children: [
              Text(
                userWithScore.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              Text(
                '${userWithScore.score} pts',
                style: TextStyle(
                  color: AppColors.purple300,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // ── Base del podio ─────────────────────────────────────────────────
        Container(
          width: 84,
          height: height,
          decoration: BoxDecoration(
            gradient: _rankGradient,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            '$rank',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}