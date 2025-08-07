import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignIn;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/cqrs/command_bus.dart';
import 'package:recetasperuanas/core/events/domain_event.dart';
import 'package:recetasperuanas/core/network/api_service.dart';
import 'package:recetasperuanas/core/provider/locale_provider.dart';
import 'package:recetasperuanas/core/provider/theme_provider.dart';
import 'package:recetasperuanas/core/saga/saga.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_repository.dart';
import 'package:recetasperuanas/infrastructure/auth/repositories/firebase_user_auth_repository.dart';

List<SingleChildWidget> globalProviders(BuildContext context) {
  // Services
  final apiService = ApiService();

  // Repositories
  final userRepository = UserRepository(apiService: apiService);
  final userAuthRepository = FirebaseUserAuthRepository(
    FirebaseAuth.instance,
    GoogleSignIn(scopes: <String>['email', 'profile']),
  );

  return [
    // Services Layer
    Provider<ApiService>.value(value: apiService),

    // Repository Layer - Use interfaces for dependency inversion
    Provider<IUserAuthRepository>.value(value: userAuthRepository),
    Provider<IUserRepository>.value(value: userRepository),

    // UI Providers
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),

    // CQRS & Events
    Provider<CommandBus>.value(value: CommandBus.instance),
    Provider<QueryBus>.value(value: QueryBus.instance),
    Provider<EventBus>.value(value: EventBus.instance),
    Provider<SagaOrchestrator>.value(value: SagaOrchestrator.instance),
  ];
}
