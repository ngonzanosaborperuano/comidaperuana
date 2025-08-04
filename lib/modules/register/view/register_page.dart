import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/network/api_service.dart';
import 'package:recetasperuanas/modules/register/controller/register_controller.dart';
import 'package:recetasperuanas/modules/register/view/register_view.dart';
import 'package:recetasperuanas/shared/widget/app_scaffold/app_scaffold.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  factory RegisterPage.routeBuilder(_, _) {
    return const RegisterPage(key: Key('register_page'));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterController>(
      create:
          (_) => RegisterController(
            userRepository: UserRepository(apiService: ApiService()),
          ),
      child: const AppScaffold(toolbarHeight: 0, body: RegisterView()),
    );
  }
}
