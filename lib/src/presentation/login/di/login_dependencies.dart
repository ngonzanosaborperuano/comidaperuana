import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/src/application/use_cases/login_use_case.dart';
import 'package:goncook/src/application/use_cases/logout_use_case.dart';
import 'package:goncook/src/application/use_cases/register_use_case.dart';
import 'package:goncook/src/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:goncook/src/domain/auth/repositories/i_user_repository.dart';
import 'package:goncook/src/presentation/login/bloc/login_bloc.dart';

/// Dependencias específicas del módulo de login
List<BlocProvider> loginModuleProviders(BuildContext context) {
  return [
    // Login BLoC
    BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(
        loginUseCase: LoginUseCase(context.read<IUserAuthRepository>()),
        registerUseCase: RegisterUseCase(context.read<IUserAuthRepository>()),
        logoutUseCase: LogoutUseCase(context.read<IUserAuthRepository>()),
        userRepository: context.read<IUserRepository>(),
      ),
    ),
  ];
}
