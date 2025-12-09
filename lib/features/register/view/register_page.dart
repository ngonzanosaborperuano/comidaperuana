import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/core/extension/extension.dart';
import 'package:goncook/features/auth/domain/repositories/i_user_repository.dart';
import 'package:goncook/features/auth/domain/usecases/register_usecase.dart';
import 'package:goncook/features/register/bloc/register_bloc.dart';
import 'package:goncook/features/register/di/register_dependencies.dart';
import 'package:goncook/features/register/view/register_view.dart';

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
        create: (context) => RegisterBloc(
          registerUseCase: context.read<RegisterUseCase>(),
          userRepository: context.read<IUserRepository>(),
        ),
        child: Scaffold(
          body: const RegisterView(),
          appBar: AppBar(title: Text(context.loc.register)),
        ),
      ),
    );
  }
}
