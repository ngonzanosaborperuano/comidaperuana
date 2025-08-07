import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider, MultiProvider, ReadContext;
import 'package:recetasperuanas/application/auth/use_cases/register_use_case.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_repository.dart';
import 'package:recetasperuanas/modules/register/controller/register_controller.dart';
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
    return MultiProvider(
      providers: [
        ...registerModuleProviders(context),
        ChangeNotifierProvider(
          create:
              (_) => RegisterController(
                userRepository: context.read<IUserRepository>(),
                registerUseCase: context.read<RegisterUseCase>(),
              ),
        ),
      ],
      child: const AppScaffold(toolbarHeight: 0, body: RegisterView()),
    );
  }
}
