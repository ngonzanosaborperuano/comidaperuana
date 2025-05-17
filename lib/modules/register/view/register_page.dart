import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/core/network/api_service.dart';
import 'package:recetasperuanas/modules/register/controller/register_controller.dart';
import 'package:recetasperuanas/modules/register/view/register_view.dart';

import 'package:recetasperuanas/shared/widget/app_scaffold.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  factory RegisterPage.routeBuilder(_, __) {
    return RegisterPage(key: const Key('register_page'));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterController>(
      create:
          (_) => RegisterController(
            userRepository: UserRepository(apiService: ApiService()),
          ),
      child: AppScaffold(
        body: RegisterView(),
        onBackPressed: () {
          context.go(Routes.login.description);
        },
      ),
    );
  }
}
