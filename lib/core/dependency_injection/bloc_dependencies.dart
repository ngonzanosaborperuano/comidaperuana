import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/core/dependency_inversion/dependencies.dart';

/// Lista de BLoCs globales de la aplicación
/// Centraliza la inyección de dependencias de BLoCs a nivel de aplicación.
List<BlocProvider> globalBlocProviders(BuildContext context) {
  return [
    // Theme BLoC
    BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),

    // Locale BLoC
    BlocProvider<LocaleBloc>(create: (context) => LocaleBloc()),

    // Pages BLoC ahora es local al shell (Home/AppScaffold) para evitar persistencia entre sesiones
  ];
}

/// Lista de repositories para inyección de dependencias
/// Centraliza la inyección de dependencias de repositorios a nivel de aplicación.
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
      create: (context) => UserRepository(apiService: context.read<ApiService>()),
    ),
  ];
}
