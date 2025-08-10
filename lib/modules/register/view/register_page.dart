import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetasperuanas/application/auth/use_cases/register_use_case.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_repository.dart';
import 'package:recetasperuanas/modules/register/bloc/register_bloc.dart';
import 'package:recetasperuanas/modules/register/di/register_dependencies.dart';
import 'package:recetasperuanas/modules/register/view/register_view.dart';
import 'package:recetasperuanas/shared/widget/app_scaffold/app_scaffold.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  factory RegisterPage.routeBuilder(_, _) {
    return const RegisterPage(key: Key('register_page'));
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: registerModuleProviders(context),
      child: BlocProvider<RegisterBloc>(
        create:
            (context) => RegisterBloc(
              registerUseCase: context.read<RegisterUseCase>(),
              userRepository: context.read<IUserRepository>(),
            ),
        child: const AppScaffold(toolbarHeight: 0, body: RegisterView()),
      ),
    );
  }
}
