import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:recetasperuanas/application/auth/use_cases/login_use_case.dart';
import 'package:recetasperuanas/application/auth/use_cases/logout_use_case.dart';
import 'package:recetasperuanas/application/auth/use_cases/register_use_case.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_auth_repository.dart';

/// Dependencias específicas del módulo de login
List<SingleChildWidget> loginModuleProviders(BuildContext context) {
  final userAuthRepository = context.read<IUserAuthRepository>();

  return [
    // Use Cases específicos del módulo de login
    Provider<LoginUseCase>.value(value: LoginUseCase(userAuthRepository)),
    Provider<RegisterUseCase>.value(value: RegisterUseCase(userAuthRepository)),
    Provider<LogoutUseCase>.value(value: LogoutUseCase(userAuthRepository)),
  ];
}
