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
    required player,
  });

  LinearGradient _getRankGradient() {
    switch (rank) {
      case 1:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFBBF24),
            Color(0xFFCA8A04),
          ], // yellow-400 to yellow-600
        );
      case 2:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD1D5DB),
            Color(0xFF6B7280),
          ], // gray-300 to gray-500
        );
      case 3:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD97706),
            Color(0xFF92400E),
          ], // amber-600 to amber-800
        );
      default:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8B5CF6),
            Color(0xFF7C3AED),
          ], // purple-500 to purple-700
        );
    }
  }

  String _getRankIcon() {
    switch (rank) {
      case 1:
        return '👑';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar con icono
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: userWithScore.isCurrentUser
                  ? BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFEF4444), // red-500
                        width: 4,
                      ),
                    )
                  : null,
              child: ImageWithFallback(
                imageUrl: userWithScore.avatar,
                width: 64,
                height: 64,
                borderRadius: 32,
                borderWidth: 2,
                borderColor: Colors.white,
              ),
            ),
            if (rank <= 3)
              Positioned(
                top: -8,
                right: -8,
                child: Text(
                  _getRankIcon(),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Información del jugador
        SizedBox(
          width: 80,
          child: Column(
            children: [
              Text(
                userWithScore.displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '${userWithScore.score.toString()} pts',
                style: const TextStyle(
                  color: Color(0xFFE9D5FF), // purple-200
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Base del podio
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            gradient: _getRankGradient(),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            rank.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
