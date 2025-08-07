import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider, MultiProvider, ReadContext;
import 'package:recetasperuanas/application/auth/use_cases/login_use_case.dart';
import 'package:recetasperuanas/application/auth/use_cases/logout_use_case.dart';
import 'package:recetasperuanas/application/auth/use_cases/register_use_case.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_repository.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart'
    show LoginController;
import 'package:recetasperuanas/modules/login/di/login_dependencies.dart';
import 'package:recetasperuanas/modules/login/view/login_view.dart';
import 'package:recetasperuanas/shared/widget/app_scaffold/app_scaffold.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  factory LoginPage.routeBuilder(_, _) {
    return const LoginPage(key: Key('login_page'));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...loginModuleProviders(context),
        ChangeNotifierProvider(
          create:
              (context) => LoginController(
                userRepository: context.read<IUserRepository>(),
                loginUseCase: context.read<LoginUseCase>(),
                registerUseCase: context.read<RegisterUseCase>(),
                logoutUseCase: context.read<LogoutUseCase>(),
              ),
        ),
      ],
      child: const AppScaffold(body: LoginView(), toolbarHeight: 0),
    );
  }
}
