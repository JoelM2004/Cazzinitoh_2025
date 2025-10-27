import 'package:flutter/material.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/stats/circular_progress.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/stats/stats_card.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/stats/stats_table.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/stats/time_chart.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A), // slate-900
              Color(0xFF581C87), // purple-900
              Color(0xFF0F172A), // slate-900
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Color(0xFFD8B4FE),
                          ),
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.mood_bad,
                          color: Color(0xFFC084FC),
                          size: 32,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Estadísticas',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.dark_mode,
                      color: Color(0xFFC084FC),
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Main Stats Cards
                Row(
                  children: [
                    Expanded(
                      child: StatsCard(
                        title: 'Total de Retos',
                        value: '47',
                        icon: Icons.games,
                        subtitle: 'completados',
                        color: StatsCardColor.purple,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatsCard(
                        title: 'Récord Personal',
                        value: '1,250',
                        icon: Icons.emoji_events,
                        subtitle: 'puntos',
                        color: StatsCardColor.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Circular Progress Charts
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xCC581C87), Color(0x996B21A8)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0x807C3AED),
                            width: 2,
                          ),
                        ),
                        child: const CircularProgress(
                          percentage: 87,
                          title: 'Aciertos en Destinos',
                          color: Color(0xFFA855F7),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xCC7F1D1D), Color(0x99991B1B)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0x80B91C1C),
                            width: 2,
                          ),
                        ),
                        child: const CircularProgress(
                          percentage: 73,
                          title: 'Eficiencia Temporal',
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Average Time Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xE61F2937), Color(0xB31F2937)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0x80374151),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Color(0xFF9CA3AF),
                        size: 32,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Tiempo Promedio',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'por desafío completado',
                              style: TextStyle(color: Color(0xFFD1D5DB)),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            '38.2s',
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'mejorando 12%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Time Performance Chart
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xCC581C87), Color(0x996B21A8)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0x807C3AED),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.track_changes,
                            color: Color(0xFFC084FC),
                            size: 24,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Rendimiento Temporal',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const TimeChart(),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Recent Challenges Table
                const StatsTable(),
                const SizedBox(height: 24),

                // Achievement Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xCC78350F), Color(0x9992400E)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0x80B45309),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Color(0xFFFBBF24),
                        size: 48,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Último Logro',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Maestro de las Sombras',
                              style: TextStyle(color: Color(0xFFFDE68A)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Completar 50 desafíos consecutivos',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFFCD34D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Footer Navigation
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xCC7C3AED),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Color(0x807C3AED)),
                      ),
                    ),
                    child: const Text(
                      'Nuevo Desafío',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
