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
    Challenge(
      id: 1,
      name: 'Partida #1',
      score: 850,
      time: '45s',
      accuracy: '92%',
    ),
    Challenge(
      id: 2,
      name: 'Partida #2',
      score: 920,
      time: '32s',
      accuracy: '100%',
    ),
    Challenge(
      id: 3,
      name: 'Partida #3',
      score: 780,
      time: '51s',
      accuracy: '85%',
    ),
    Challenge(
      id: 4,
      name: 'Partida #4',
      score: 950,
      time: '28s',
      accuracy: '100%',
    ),
    Challenge(
      id: 5,
      name: 'Partida #5',
      score: 810,
      time: '39s',
      accuracy: '88%',
    ),
  ];

  Color _getScoreBadgeColor(int score) {
    if (score >= 900) return const Color(0xCC059669);
    if (score >= 800) return const Color(0xCC7C3AED);
    return const Color(0xCC4B5563);
  }

  Color _getScoreBorderColor(int score) {
    if (score >= 900) return const Color(0x8010B981);
    if (score >= 800) return const Color(0x807C3AED);
    return const Color(0x806B7280);
  }

  Color _getScoreTextColor(int score) {
    if (score >= 900) return const Color(0xFFD1FAE5);
    if (score >= 800) return const Color(0xFFE9D5FF);
    return const Color(0xFFF3F4F6);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xE61F2937), Color(0xB31F2937)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x80374151), width: 2),
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
              color: Colors.white,
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
                    color: Colors.grey[800]!.withOpacity(0.5),
                  ),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Desafío',
                        style: TextStyle(
                          color: Color(0xFFD1D5DB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Puntos',
                        style: TextStyle(
                          color: Color(0xFFD1D5DB),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Precisión',
                        style: TextStyle(
                          color: Color(0xFFD1D5DB),
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
                          color: const Color(0x80374151),
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          challenge.name,
                          style: const TextStyle(color: Color(0xFFE5E7EB)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getScoreBadgeColor(challenge.score),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: _getScoreBorderColor(challenge.score),
                            ),
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
                          style: const TextStyle(color: Color(0xFFD1D5DB)),
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
