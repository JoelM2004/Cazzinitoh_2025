import 'package:cazzinitoh_2025/src/features/users/data/models/score_leaderboard_model.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/leaderboard/leaderboard_bloc.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/leaderboard/ImageWithFallback.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/leaderboard/PodiumPosition.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/widgets/leaderboard/RankingList.dart';
import 'package:cazzinitoh_2025/src/features/shared/widgets/shared_widgets.dart';
import 'package:cazzinitoh_2025/src/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  static const String trophyImage =
      "https://images.unsplash.com/photo-1754300681803-61eadeb79d10?w=400";

  @override
  void initState() {
    super.initState();
    context.read<LeaderboardBloc>().add(LoadLeaderboard());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBackNavBar(title: 'Clasificación'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.purpleBackground,
              AppColors.purple900,
              AppColors.purpleBackground,
            ],
          ),
        ),
        child: SafeArea(
          child: BlocListener<LeaderboardBloc, LeaderboardState>(
            listener: (context, state) {
              if (state is LeaderboardFailure) {
                AppAlert.show(
                  context,
                  type: AlertType.error,
                  title: 'Error al cargar',
                  message: state.failure.message,
                );
              }
            },
            child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
              builder: (context, state) => switch (state) {
                LeaderboardInitial() => const SizedBox.shrink(),
                LeaderboardLoading() => const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.purpleBorder,
                    ),
                  ),
                LeaderboardSuccess(:final players) when players.isEmpty =>
                  const _EmptyView(),
                LeaderboardSuccess(:final players) =>
                  _LeaderboardContent(players: players, trophyImage: trophyImage),
                LeaderboardFailure() => _EmptyRetryView(),
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Empty (lista vacía) ──────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events_outlined,
                color: AppColors.purple300, size: 64),
            const SizedBox(height: 16),
            Text(
              'Sin jugadores aún',
              style: AppTextStyles.h2.copyWith(color: AppColors.darkForeground),
            ),
            const SizedBox(height: 8),
            Text(
              'Completá el desafío para aparecer en el ranking.',
              style: AppTextStyles.p
                  .copyWith(color: AppColors.darkMutedForeground),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton.ghost(
              label: 'Reintentar',
              icon: Icons.refresh,
              onPressed: () =>
                  context.read<LeaderboardBloc>().add(LoadLeaderboard()),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Error retry ──────────────────────────────────────────────────────────────

class _EmptyRetryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppButton.ghost(
        label: 'Reintentar',
        icon: Icons.refresh,
        onPressed: () =>
            context.read<LeaderboardBloc>().add(LoadLeaderboard()),
      ),
    );
  }
}

// ─── Content ──────────────────────────────────────────────────────────────────

class _LeaderboardContent extends StatelessWidget {
  final List<ScoreLeaderboardModel> players;
  final String trophyImage;

  const _LeaderboardContent({
    required this.players,
    required this.trophyImage,
  });

  @override
  Widget build(BuildContext context) {
    final top3 = players.take(3).toList();
    final rest = players.length > 3 ? players.sublist(3) : <ScoreLeaderboardModel>[];

    final currentUserIndex = players.indexWhere((p) => p.isCurrentUser);
    final currentUser =
        currentUserIndex != -1 ? players[currentUserIndex] : null;
    final currentUserRank =
        currentUserIndex != -1 ? currentUserIndex + 1 : null;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 448),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _Header(trophyImage: trophyImage),
                const SizedBox(height: 32),
                if (currentUser != null && currentUserRank != null) ...[
                  _CurrentUserCard(user: currentUser, rank: currentUserRank),
                  const SizedBox(height: 24),
                ],
                if (top3.isNotEmpty) ...[
                  _Podium(top3: top3),
                  const SizedBox(height: 32),
                ],
                if (rest.isNotEmpty) ...[
                  _RankingSection(rest: rest),
                  const SizedBox(height: 32),
                ],
                _ActionButtons(),
                const SizedBox(height: 32),
                _Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String trophyImage;
  const _Header({required this.trophyImage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImageWithFallback(
          imageUrl: trophyImage,
          width: 80,
          height: 80,
          borderRadius: 40,
          borderWidth: 4,
          borderColor: const Color(0xFFFBBF24),
        ),
        const SizedBox(height: 16),
        Text(
          'Clasificación Final',
          style: AppTextStyles.h1.copyWith(
            color: AppColors.darkForeground,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '¡Felicidades por completar el desafío!',
          style: AppTextStyles.p.copyWith(color: AppColors.purple300),
        ),
      ],
    );
  }
}

// ─── Current user card ────────────────────────────────────────────────────────

class _CurrentUserCard extends StatelessWidget {
  final ScoreLeaderboardModel user;
  final int rank;
  const _CurrentUserCard({required this.user, required this.rank});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.red700.withOpacity(0.5),
            AppColors.purple900.withOpacity(0.5),
          ],
        ),
        border: Border.all(color: AppColors.red500, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AppAvatar(
                imageUrl: user.avatar,
                size: 48,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tu Resultado',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.red400,
                    ),
                  ),
                  Text(
                    'Posición #$rank',
                    style: AppTextStyles.p.copyWith(
                      color: AppColors.darkForeground,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                user.score.toString(),
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.red400,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'puntos',
                style: AppTextStyles.p.copyWith(
                  fontSize: 14,
                  color: AppColors.red400.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Podium ───────────────────────────────────────────────────────────────────

class _Podium extends StatelessWidget {
  final List<ScoreLeaderboardModel> top3;
  const _Podium({required this.top3});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events,
                color: AppColors.purple300, size: 24),
            const SizedBox(width: 8),
            Text(
              'Podio de Campeones',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.purple300,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (top3.length > 1)
              PodiumPosition(rank: 2, player: top3[1], height: 80),
            const SizedBox(width: 16),
            PodiumPosition(rank: 1, player: top3[0], height: 112),
            const SizedBox(width: 16),
            if (top3.length > 2)
              PodiumPosition(rank: 3, player: top3[2], height: 64),
          ],
        ),
      ],
    );
  }
}

// ─── Ranking section ──────────────────────────────────────────────────────────

class _RankingSection extends StatelessWidget {
  final List<ScoreLeaderboardModel> rest;
  const _RankingSection({required this.rest});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Clasificación Completa',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.purple300,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        RankingList(players: rest, startRank: 4),
      ],
    );
  }
}

// ─── Action buttons ───────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton.primary(
          label: 'Jugar de Nuevo',
          icon: Icons.refresh,
          height: 56,
          onPressed: () =>
              context.read<LeaderboardBloc>().add(LoadLeaderboard()),
        ),
        const SizedBox(height: 16),
        AppButton.outline(
          label: 'Volver al Inicio',
          icon: Icons.home,
          height: 56,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

// ─── Footer ───────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.purpleCardBorder, width: 1),
        ),
      ),
      child: Text(
        'Memory Trip • Desafío completado',
        style: AppTextStyles.p.copyWith(
          fontSize: 14,
          color: AppColors.darkMutedForeground,
        ),
      ),
    );
  }
}