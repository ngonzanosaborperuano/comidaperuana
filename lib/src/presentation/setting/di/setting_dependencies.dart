import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetasperuanas/src/application/use_cases/logout_use_case.dart';
import 'package:recetasperuanas/src/domain/auth/repositories/i_user_auth_repository.dart';

/// Dependencias específicas del módulo de settings
List<RepositoryProvider> settingModuleProviders(BuildContext context) {
  final userAuthRepository = context.read<IUserAuthRepository>();

  return [
    // Use Cases específicos del módulo de settings
    RepositoryProvider<LogoutUseCase>(create: (_) => LogoutUseCase(userAuthRepository)),
  ];
}
