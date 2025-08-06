import 'package:flutter/material.dart';
import 'package:recetasperuanas/modules/login/view/login_view.dart';
import 'package:recetasperuanas/shared/widget/app_scaffold/app_scaffold.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  factory LoginPage.routeBuilder(_, _) {
    return const LoginPage(key: Key('login_page'));
  }

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(body: LoginView(), toolbarHeight: 0);
  }
}
