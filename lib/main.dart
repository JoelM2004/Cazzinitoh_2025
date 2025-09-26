import 'package:cazzinitoh_2025/di.dart';
import 'package:cazzinitoh_2025/src/app/app.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/load_user/load_user_bloc.dart';
import 'package:cazzinitoh_2025/src/features/users/presentation/bloc/login_user/login_user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.instance.get<LoadUserBloc>()),
        BlocProvider(create: (_) => GetIt.instance.get<LoginUserBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}
