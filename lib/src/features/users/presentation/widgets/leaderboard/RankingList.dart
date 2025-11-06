import 'package:cazzinitoh_2025/src/features/users/data/models/user_model.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/leaderboard/ImageWithFallback.dart';
import 'package:flutter/material.dart';

class RankingList extends StatelessWidget {
  final List<UserWithScore> players;
  final int startRank;

  const RankingList({
    super.key,
    required this.players,
    required this.startRank,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(players.length, (index) {
        final userWithScore = players[index];
        final rank = startRank + index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _RankingItem(userWithScore: userWithScore, rank: rank),
        );
      }),
    );
  }
}

class _RankingItem extends StatelessWidget {
  final UserWithScore userWithScore;
  final int rank;

  const _RankingItem({required this.userWithScore, required this.rank});

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = userWithScore.isCurrentUser;

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? const Color(0x4D7F1D1D) // red-900/30
            : const Color(0x801F2937), // gray-800/50
        border: Border.all(
          color: isCurrentUser
              ? const Color(0xFFEF4444) // red-500
              : const Color(0xFF374151), // gray-700
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isCurrentUser
            ? [
                BoxShadow(
                  color: const Color(0xFFF87171).withOpacity(0.5), // red-400/50
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                // Rank Number
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? const Color(0xFFDC2626) // red-600
                        : const Color(0xFF9333EA), // purple-600
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    rank.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Avatar
                ImageWithFallback(
                  imageUrl: userWithScore.avatar,
                  width: 48,
                  height: 48,
                  borderRadius: 24,
                  borderWidth: 2,
                  borderColor: const Color(0xFF4B5563), // gray-600
                ),
                const SizedBox(width: 16),

                // Player Name
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          userWithScore.displayName,
                          style: TextStyle(
                            color: isCurrentUser
                                ? const Color(0xFFFCA5A5) // red-300
                                : Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDC2626), // red-600
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'TÚ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    userWithScore.score.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isCurrentUser
                          ? const Color(0xFFFCA5A5) // red-300
                          : const Color(0xFFC4B5FD), // purple-300
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'pts',
                    style: TextStyle(
                      fontSize: 14,
                      color: isCurrentUser
                          ? const Color(0xFFFCA5A5) // red-300
                          : const Color(0xFFC4B5FD), // purple-300
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
