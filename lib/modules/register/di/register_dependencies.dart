import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetasperuanas/application/auth/use_cases/register_use_case.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_auth_repository.dart';

/// Dependencias específicas del módulo de register
List<RepositoryProvider> registerModuleProviders(BuildContext context) {
  final userAuthRepository = context.read<IUserAuthRepository>();

  return [
    // Use Cases específicos del módulo de register
    RepositoryProvider<RegisterUseCase>(create: (_) => RegisterUseCase(userAuthRepository)),
  ];
}
