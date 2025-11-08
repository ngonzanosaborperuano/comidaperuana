import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recetasperuanas/src/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:recetasperuanas/src/domain/auth/repositories/i_user_repository.dart';
import 'package:recetasperuanas/src/infrastructure/auth/repositories/firebase_user_auth_repository.dart';
import 'package:recetasperuanas/src/infrastructure/auth/repositories/user_repository.dart';
import 'package:recetasperuanas/src/infrastructure/shared/network/api_service.dart';
import 'package:recetasperuanas/src/presentation/core/bloc/app_bloc.dart';
import 'package:recetasperuanas/src/presentation/core/bloc/auth_bloc.dart';
import 'package:recetasperuanas/src/presentation/core/bloc/config_bloc.dart';
import 'package:recetasperuanas/src/presentation/core/bloc/locale_bloc.dart';
import 'package:recetasperuanas/src/presentation/core/bloc/theme_bloc.dart';
import 'package:recetasperuanas/src/presentation/core/bloc/user_bloc.dart';

/// Lista de BLoCs globales de la aplicación
List<BlocProvider> globalBlocProviders(BuildContext context) {
  return [
    // App BLoC
    BlocProvider<AppBloc>(create: (context) => AppBloc()),

    // Auth BLoC
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(authRepository: context.read<IUserAuthRepository>()),
    ),

    // User BLoC
    BlocProvider<UserBloc>(
      create: (context) => UserBloc(userRepository: context.read<IUserRepository>()),
    ),

    // Config BLoC
    BlocProvider<ConfigBloc>(
      create: (context) => ConfigBloc(
        config: <String, dynamic>{'theme': 'light', 'locale': 'es', 'version': '1.0.0'},
      ),
    ),

    // Theme BLoC
    BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),

    // Locale BLoC
    BlocProvider<LocaleBloc>(create: (context) => LocaleBloc()),

    // Pages BLoC ahora es local al shell (Home/AppScaffold) para evitar persistencia entre sesiones
  ];
}

/// Lista de repositories para inyección de dependencias
List<RepositoryProvider> globalRepositoryProviders(BuildContext context) {
  return [
    // Core services
    RepositoryProvider<ApiService>(create: (_) => ApiService()),

    // Auth Repository
    RepositoryProvider<IUserAuthRepository>(
      create: (context) => FirebaseUserAuthRepository(
        FirebaseAuth.instance,
        GoogleSignIn(scopes: ['email', 'profile']),
      ),
    ),

    // User Repository
    RepositoryProvider<IUserRepository>(
      create: (context) => UserRepository(apiService: context.read<ApiServiceImpl>()),
    ),
  ];
}
