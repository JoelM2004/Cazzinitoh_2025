import 'package:cazzinitoh_2025/src/features/users/data/models/score_leaderboard_model.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/leaderboard/ImageWithFallback.dart';
import 'package:flutter/material.dart';

class RankingList extends StatelessWidget {
  final List<ScoreLeaderboardModel> players;
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
        final player = players[index];
        final rank = startRank + index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _RankingItem(player: player, rank: rank),
        );
      }),
    );
  }
}

class _RankingItem extends StatelessWidget {
  final ScoreLeaderboardModel player;
  final int rank;

  const _RankingItem({required this.player, required this.rank});

  @override
  Widget build(BuildContext context) {
    final isCurrentUser = player.isCurrentUser;

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? const Color(0x4D7F1D1D)
            : const Color(0x801F2937),
        border: Border.all(
          color: isCurrentUser
              ? const Color(0xFFEF4444)
              : const Color(0xFF374151),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isCurrentUser
            ? [
                BoxShadow(
                  color: const Color(0xFFF87171).withOpacity(0.5),
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
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF9333EA),
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
                  imageUrl: player.avatar,
                  width: 48,
                  height: 48,
                  borderRadius: 24,
                  borderWidth: 2,
                  borderColor: const Color(0xFF4B5563),
                ),
                const SizedBox(width: 16),

                // Player Name
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          player.displayName,
                          style: TextStyle(
                            color: isCurrentUser
                                ? const Color(0xFFFCA5A5)
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
                            color: const Color(0xFFDC2626),
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
                    player.score.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isCurrentUser
                          ? const Color(0xFFFCA5A5)
                          : const Color(0xFFC4B5FD),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'pts',
                    style: TextStyle(
                      fontSize: 14,
                      color: isCurrentUser
                          ? const Color(0xFFFCA5A5)
                          : const Color(0xFFC4B5FD),
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