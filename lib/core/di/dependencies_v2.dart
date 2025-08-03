import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:recetasperuanas/application/auth/use_cases/login_use_case.dart';
import 'package:recetasperuanas/core/provider/locale_provider.dart';
import 'package:recetasperuanas/core/provider/theme_provider.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:recetasperuanas/infrastructure/auth/repositories/firebase_user_auth_repository.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart';

/// Enhanced dependency injection with DDD architecture
class DependencyInjection {
  static DependencyInjection? _instance;
  static DependencyInjection get instance => _instance ??= DependencyInjection._();

  DependencyInjection._();

  // Repositories
  late final IUserAuthRepository _userAuthRepository = FirebaseUserAuthRepository();

  // Use Cases
  late final LoginUseCase _loginUseCase = LoginUseCase(_userAuthRepository);
  late final RegisterUseCase _registerUseCase = RegisterUseCase(_userAuthRepository);
  late final LogoutUseCase _logoutUseCase = LogoutUseCase(_userAuthRepository);

  // Getters
  IUserAuthRepository get userAuthRepository => _userAuthRepository;
  LoginUseCase get loginUseCase => _loginUseCase;
  RegisterUseCase get registerUseCase => _registerUseCase;
  LogoutUseCase get logoutUseCase => _logoutUseCase;

  /// Get all providers for the app
  List<SingleChildWidget> get providers => [
    // Repositories
    Provider<IUserAuthRepository>.value(value: _userAuthRepository),

    // Use Cases
    Provider<LoginUseCase>.value(value: _loginUseCase),
    Provider<RegisterUseCase>.value(value: _registerUseCase),
    Provider<LogoutUseCase>.value(value: _logoutUseCase),

    // Controllers
    ChangeNotifierProvider(
      create:
          (context) => LoginController(
            loginUseCase: _loginUseCase,
            registerUseCase: _registerUseCase,
            logoutUseCase: _logoutUseCase,
          )..init(context),
    ),

    // UI Providers
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ];
}

/// Legacy function for backward compatibility
List<SingleChildWidget> globalProviders(BuildContext context) {
  return DependencyInjection.instance.providers;
}
