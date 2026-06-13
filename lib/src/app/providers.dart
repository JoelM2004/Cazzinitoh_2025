import 'package:cazzinitoh_2025/src/features/games/presentation/blocs/game_bloc.dart';
import 'package:cazzinitoh_2025/src/features/games/presentation/blocs/stats/stats_bloc.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/leaderboard/leaderboard_bloc.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/load_user/load_user_bloc.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/login_user/login_user_bloc.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/register_user/register_user_bloc.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/update_user/update_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.instance.get<LoadUserBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<LoginUserBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<RegisterUserBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<UpdateUserBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<LeaderboardBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<GameBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<StatsBloc>()),
      ],
      child: child,
    );
  }
}