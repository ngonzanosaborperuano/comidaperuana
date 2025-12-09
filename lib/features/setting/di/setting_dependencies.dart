import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/features/auth/domain/repositories/i_user_auth_repository.dart';
import 'package:goncook/features/auth/domain/usecases/logout_usecase.dart';

/// Dependencias específicas del módulo de settings
List<RepositoryProvider> settingModuleProviders(BuildContext context) {
  final userAuthRepository = context.read<IUserAuthRepository>();

  return [
    // Use Cases específicos del módulo de settings
    RepositoryProvider<LogoutUseCase>(create: (_) => LogoutUseCase(userAuthRepository)),
  ];
}
