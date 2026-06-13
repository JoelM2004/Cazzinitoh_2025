import 'package:cazzinitoh_2025/src/app/routes.dart';
import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:cazzinitoh_2025/src/core/session/session.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/blocs/stats/stats_bloc.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/widgets/stats/circular_progress.dart';
import 'package:cazzinitoh_2025/src/features/users/domain/entities/score_leaderboard.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/leaderboard/leaderboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  void initState() {
    super.initState();
    final userId = Session.currentUser?.id ?? '';
    context.read<StatsBloc>().add(StatsFetchRequested(userId));
    context.read<LeaderboardBloc>().add(LoadLeaderboard());
  }

  String _formatTime(double seconds) {
    final m = (seconds / 60).floor();
    final s = (seconds % 60).floor();
    if (m == 0) return '${s}s';
    return '${m}m ${s}s';
  }

  int _efficiencyPercent(double? time, int? matchs) {
    if (time == null || matchs == null || matchs == 0) return 0;
    final avg = time / matchs;
    return (100 - ((avg - 30) / 30 * 100)).clamp(0, 100).toInt();
  }

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
          child: BlocBuilder<StatsBloc, StatsState>(
            builder: (context, statsState) {
              final stats = statsState.stats;
              final loading = statsState.status == StatsStatus.loading;
              final userScores = statsState.userScores;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ────────────────────────────────────────
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppColors.purple300),
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.menu, 
                            (route) => false,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.bar_chart, color: AppColors.purple400, size: 28),
                        const SizedBox(width: 8),
                        const Text(
                          'Estadísticas',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkForeground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Cards principales ─────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Partidas',
                            value: loading ? '—' : '${stats?.matchs ?? 0}',
                            icon: Icons.games,
                            subtitle: 'jugadas',
                            color: const Color(0xFF7c3aed),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Récord',
                            value: loading
                                ? '—'
                                : userScores.isNotEmpty
                                    ? '${userScores.first.score}'
                                    : '0',
                            icon: Icons.emoji_events,
                            subtitle: 'puntos',
                            color: const Color(0xFFdc2626),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Tiempo total',
                            value: loading ? '—' : _formatTime(stats?.time ?? 0),
                            icon: Icons.timer,
                            subtitle: 'acumulado',
                            color: const Color(0xFF0891b2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Precisión',
                            value: loading
                                ? '—'
                                : '${(stats?.accuracy ?? 0).toStringAsFixed(1)}%',
                            icon: Icons.gps_fixed,
                            subtitle: 'promedio',
                            color: const Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Círculos de progreso ──────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _ProgressCard(
                            percentage: loading
                                ? 0
                                : (stats?.accuracy ?? 0).clamp(0, 100).toInt(),
                            title: 'Precisión\nglobal',
                            color: AppColors.purple500,
                            borderColor: AppColors.purple700,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _ProgressCard(
                            percentage: loading
                                ? 0
                                : _efficiencyPercent(stats?.time, stats?.matchs),
                            title: 'Eficiencia\ntemporal',
                            color: const Color(0xFFef4444),
                            borderColor: const Color(0xFF991b1b),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Tiempo promedio por partida ───────────────────
                    _InfoRow(
                      icon: Icons.access_time,
                      title: 'Tiempo promedio',
                      subtitle: 'por partida',
                      valueText: loading
                          ? '—'
                          : _formatTime(
                              (stats?.matchs ?? 0) > 0
                                  ? (stats!.time / stats.matchs)
                                  : 0,
                            ),
                      secondText: '${stats?.matchs ?? 0} partidas',
                    ),
                    const SizedBox(height: 16),

                    // ── Distancia total ───────────────────────────────
                    _InfoRow(
                      icon: Icons.directions_walk,
                      title: 'Distancia recorrida',
                      subtitle: 'total histórico',
                      valueText: loading ? '—' : '${stats?.mts ?? 0} m',
                      secondText: 'caminando',
                    ),
                    const SizedBox(height: 24),

                    // ── Tus partidas ──────────────────────────────────
                    _SectionTitle(icon: Icons.history, label: 'Tus partidas'),
                    const SizedBox(height: 12),
                    if (loading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: CircularProgressIndicator(color: Color(0xFF7c3aed)),
                        ),
                      )
                    else if (userScores.isEmpty)
                      const _EmptyState(msg: 'Todavía no jugaste ninguna partida')
                    else
                      _UserScoresTable(scores: userScores),
                    const SizedBox(height: 24),

                    // ── Leaderboard global ────────────────────────────
                    _SectionTitle(icon: Icons.leaderboard, label: 'Leaderboard global'),
                    const SizedBox(height: 12),
                    BlocBuilder<LeaderboardBloc, LeaderboardState>(
                      builder: (context, lb) {
                        if (lb is LeaderboardLoading || lb is LeaderboardInitial) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: CircularProgressIndicator(color: Color(0xFF7c3aed)),
                            ),
                          );
                        }
                        if (lb is LeaderboardFailure || lb is! LeaderboardSuccess) {
                          return const _EmptyState(msg: 'Sin datos del leaderboard');
                        }
                        final entries = (lb as LeaderboardSuccess).players;
                        if (entries.isEmpty) {
                          return const _EmptyState(msg: 'Sin partidas registradas aún');
                        }
                        return _LeaderboardTable(entries: entries);
                      },
                    ),
                    const SizedBox(height: 32),

                    // ── Botón nuevo desafío ───────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.menu,
                          (route) => false,
                        ),
                        icon: const Icon(Icons.play_arrow, color: Colors.white),
                        label: const Text(
                          'Nuevo Desafío',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7c3aed),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Widgets internos
// ─────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final String subtitle;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.25), color.withOpacity(0.10)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                      color: color, fontSize: 12, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final int percentage;
  final String title;
  final Color color;
  final Color borderColor;

  const _ProgressCard({
    required this.percentage,
    required this.title,
    required this.color,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: borderColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withOpacity(0.5)),
      ),
      child: CircularProgress(
        percentage: percentage,
        title: title,
        color: color,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String valueText;
  final String secondText;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.valueText,
    required this.secondText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1033).withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4c1d95).withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFa78bfa), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 15)),
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.5), fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(valueText,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Text(secondText,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.4), fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionTitle({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFa78bfa), size: 20),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _UserScoresTable extends StatelessWidget {
  final List<ScoreLeaderboard> scores;
  const _UserScoresTable({required this.scores});

  @override
  Widget build(BuildContext context) {
    final count = scores.length > 10 ? 10 : scores.length;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1a1033).withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4c1d95).withOpacity(0.4)),
      ),
      child: Column(
        children: List.generate(count, (i) {
          final entry = scores[i];
          final isTop = i == 0;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isTop
                  ? const Color(0xFFFACC15).withOpacity(0.08)
                  : Colors.transparent,
              border: i < count - 1
                  ? Border(
                      bottom: BorderSide(
                          color: const Color(0xFF4c1d95).withOpacity(0.3)))
                  : null,
              borderRadius: i == 0
                  ? const BorderRadius.vertical(top: Radius.circular(12))
                  : i == count - 1
                      ? const BorderRadius.vertical(bottom: Radius.circular(12))
                      : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    i == 0 ? '🏆' : '#${i + 1}',
                    style: TextStyle(
                        fontSize: i == 0 ? 18 : 13, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Partida ${i + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                Text(
                  '${entry.score} pts',
                  style: TextStyle(
                    color: isTop
                        ? const Color(0xFFFACC15)
                        : Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _LeaderboardTable extends StatelessWidget {
  final List entries;
  const _LeaderboardTable({required this.entries});

  @override
  Widget build(BuildContext context) {
    final currentUserId = Session.currentUser?.id ?? '';
    final count = entries.length > 10 ? 10 : entries.length;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1a1033).withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4c1d95).withOpacity(0.4)),
      ),
      child: Column(
        children: List.generate(count, (i) {
          final entry = entries[i];
          final isMe = entry.user.id == currentUserId;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isMe
                  ? const Color(0xFF7c3aed).withOpacity(0.15)
                  : Colors.transparent,
              border: i < count - 1
                  ? Border(
                      bottom: BorderSide(
                          color: const Color(0xFF4c1d95).withOpacity(0.3)))
                  : null,
              borderRadius: i == 0
                  ? const BorderRadius.vertical(top: Radius.circular(12))
                  : i == count - 1
                      ? const BorderRadius.vertical(bottom: Radius.circular(12))
                      : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Text(
                    i == 0
                        ? '🥇'
                        : i == 1
                            ? '🥈'
                            : i == 2
                                ? '🥉'
                                : '#${i + 1}',
                    style: TextStyle(
                      fontSize: i < 3 ? 18 : 13,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF7c3aed).withOpacity(0.3),
                  child: Text(
                    (entry.user.name?.isNotEmpty == true
                            ? entry.user.name![0]
                            : '?')
                        .toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isMe
                        ? '${entry.user.name ?? 'Tú'} (vos)'
                        : entry.user.name ?? 'Usuario',
                    style: TextStyle(
                      color: isMe ? const Color(0xFFc4b5fd) : Colors.white,
                      fontWeight:
                          isMe ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${entry.score}',
                  style: TextStyle(
                    color: isMe
                        ? const Color(0xFFFACC15)
                        : Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String msg;
  const _EmptyState({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1033).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4c1d95).withOpacity(0.3)),
      ),
      child: Center(
        child: Text(msg,
            style:
                TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14)),
      ),
    );
  }
}