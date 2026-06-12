import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:flutter/material.dart';

class Challenge {
  final int id;
  final String name;
  final int score;
  final String time;
  final String accuracy;

  Challenge({
    required this.id,
    required this.name,
    required this.score,
    required this.time,
    required this.accuracy,
  });
}

class StatsTable extends StatelessWidget {
  const StatsTable({super.key});

  static final List<Challenge> recentChallenges = [
    Challenge(id: 1, name: 'Partida #1', score: 850, time: '45s', accuracy: '92%'),
    Challenge(id: 2, name: 'Partida #2', score: 920, time: '32s', accuracy: '100%'),
    Challenge(id: 3, name: 'Partida #3', score: 780, time: '51s', accuracy: '85%'),
    Challenge(id: 4, name: 'Partida #4', score: 950, time: '28s', accuracy: '100%'),
    Challenge(id: 5, name: 'Partida #5', score: 810, time: '39s', accuracy: '88%'),
  ];

  Color _getScoreBadgeColor(int score) {
    if (score >= 900) return const Color(0xCC059669); // verde — no tiene equivalente en AppColors, se mantiene
    if (score >= 800) return AppColors.purple700.withOpacity(0.8);
    return AppColors.darkMuted.withOpacity(0.8);
  }

  Color _getScoreBorderColor(int score) {
    if (score >= 900) return const Color(0x8010B981); // verde — se mantiene
    if (score >= 800) return AppColors.purple700.withOpacity(0.5);
    return AppColors.darkMuted.withOpacity(0.5);
  }

  Color _getScoreTextColor(int score) {
    if (score >= 900) return const Color(0xFFD1FAE5); // verde claro — se mantiene
    if (score >= 800) return AppColors.purple300;
    return AppColors.darkForeground;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.purpleCard.withOpacity(0.9),
            AppColors.purpleCard.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.purpleCardBorder.withOpacity(0.5), width: 2),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Acertijos Recientes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkForeground,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1.5),
              },
              children: [
                // Header
                TableRow(
                  decoration: BoxDecoration(
                    color: AppColors.darkSecondary.withOpacity(0.5),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Desafío',
                        style: TextStyle(
                          color: AppColors.darkMutedForeground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Puntos',
                        style: TextStyle(
                          color: AppColors.darkMutedForeground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Precisión',
                        style: TextStyle(
                          color: AppColors.darkMutedForeground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                // Data rows
                ...recentChallenges.map((challenge) {
                  return TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppColors.purpleCardBorder.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          challenge.name,
                          style: const TextStyle(color: AppColors.darkForeground),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getScoreBadgeColor(challenge.score),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: _getScoreBorderColor(challenge.score)),
                          ),
                          child: Text(
                            challenge.score.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _getScoreTextColor(challenge.score),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          challenge.accuracy,
                          style: const TextStyle(color: AppColors.darkMutedForeground),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}