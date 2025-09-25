import 'package:cazzinitoh_2025/di.dart';
import 'package:cazzinitoh_2025/src/app/app.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/load_user/load_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

void main() async {
  await init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.instance.get<LoadUserBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}
