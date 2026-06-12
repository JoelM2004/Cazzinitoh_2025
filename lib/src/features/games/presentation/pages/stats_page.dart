import 'package:cazzinitoh_2025/src/app/theme.dart';
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
              AppColors.purpleBackground,
              AppColors.purple900,
              AppColors.purpleBackground,
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
                          icon: const Icon(Icons.arrow_back, color: AppColors.purple300),
                          onPressed: () {
                            if (Navigator.canPop(context)) Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.mood_bad, color: AppColors.purple400, size: 32),
                        const SizedBox(width: 8),
                        const Text(
                          'Estadísticas',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkForeground,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.dark_mode, color: AppColors.purple400, size: 24),
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
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.purple900.withOpacity(0.8),
                              AppColors.purple900.withOpacity(0.6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.purple700.withOpacity(0.5), width: 2),
                        ),
                        child: const CircularProgress(
                          percentage: 87,
                          title: 'Aciertos en Destinos',
                          color: AppColors.purple500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.red700.withOpacity(0.8),
                              AppColors.red700.withOpacity(0.6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.red700.withOpacity(0.5), width: 2),
                        ),
                        child: const CircularProgress(
                          percentage: 73,
                          title: 'Eficiencia Temporal',
                          color: AppColors.red500,
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
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: AppColors.darkMutedForeground, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Tiempo Promedio',
                              style: TextStyle(fontSize: 20, color: AppColors.darkForeground),
                            ),
                            Text(
                              'por desafío completado',
                              style: TextStyle(color: AppColors.darkMutedForeground),
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
                              color: AppColors.darkForeground,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'mejorando 12%',
                            style: TextStyle(fontSize: 12, color: AppColors.darkMutedForeground),
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
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.purple900.withOpacity(0.8),
                        AppColors.purple900.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.purple700.withOpacity(0.5), width: 2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.track_changes, color: AppColors.purple400, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Rendimiento Temporal',
                            style: TextStyle(fontSize: 20, color: AppColors.darkForeground),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TimeChart(),
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
                      colors: [
                        Color(0xCC78350F), // amber-900 — sin equivalente en AppColors
                        Color(0x9992400E),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x80B45309), width: 2),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.emoji_events, color: Color(0xFFFBBF24), size: 48),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Último Logro',
                              style: TextStyle(fontSize: 20, color: AppColors.darkForeground),
                            ),
                            Text(
                              'Maestro de las Sombras',
                              style: TextStyle(color: Color(0xFFFDE68A)),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Completar 50 desafíos consecutivos',
                              style: TextStyle(fontSize: 12, color: Color(0xFFFCD34D)),
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
                      backgroundColor: AppColors.purple700.withOpacity(0.8),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: AppColors.purple700.withOpacity(0.5)),
                      ),
                    ),
                    child: const Text(
                      'Nuevo Desafío',
                      style: TextStyle(fontSize: 16, color: AppColors.darkForeground),
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