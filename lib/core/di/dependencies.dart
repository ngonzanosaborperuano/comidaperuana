import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignIn;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:recetasperuanas/application/auth/use_cases/login_use_case.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/cqrs/command_bus.dart';
import 'package:recetasperuanas/core/events/domain_event.dart';
import 'package:recetasperuanas/core/network/api_service.dart';
import 'package:recetasperuanas/core/provider/app_state_provider.dart';
import 'package:recetasperuanas/core/provider/locale_provider.dart';
import 'package:recetasperuanas/core/provider/theme_provider.dart';
import 'package:recetasperuanas/core/saga/saga.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_repository.dart' as userrepo;
import 'package:recetasperuanas/infrastructure/auth/repositories/firebase_user_auth_repository.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart'
    show LoginController;
import 'package:recetasperuanas/modules/login/controller/login_controller_old.dart';

List<SingleChildWidget> globalProviders(BuildContext context) {
  // Services
  final apiService = ApiService();

  // Repositories
  final userRepository = UserRepository(apiService: apiService);
  final userAuthRepository = FirebaseUserAuthRepository(
    FirebaseAuth.instance,
    GoogleSignIn(scopes: <String>['email', 'profile']),
  );

  // Use Cases
  final loginUseCase = LoginUseCase(userAuthRepository);
  final registerUseCase = RegisterUseCase(userAuthRepository);
  final logoutUseCase = LogoutUseCase(userAuthRepository);

  return [
    // Legacy providers for backward compatibility
    Provider<UserRepository>.value(value: userRepository),
    Provider<ApiService>.value(value: apiService),

    // New providers
    ChangeNotifierProvider(create: (_) => AppStateProvider()),
    Provider<IUserAuthRepository>.value(value: userAuthRepository),
    Provider<userrepo.IUserRepository>.value(value: userRepository),
    Provider<LoginUseCase>.value(value: loginUseCase),
    Provider<RegisterUseCase>.value(value: registerUseCase),
    Provider<LogoutUseCase>.value(value: logoutUseCase),

    // Controllers
    ChangeNotifierProvider(
      create:
          (_) => LoginController(
            userRepository: userRepository,
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
            logoutUseCase: logoutUseCase,
          ),
    ),
    ChangeNotifierProvider(create: (_) => LoginControllerOld(userRepository: userRepository)),

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
