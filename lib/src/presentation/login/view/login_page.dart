import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/src/presentation/login/di/login_dependencies.dart';
import 'package:goncook/src/presentation/presentation.dart' show LoginView;
import 'package:goncook/src/shared/widget/app_scaffold/app_scaffold.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  factory LoginPage.routeBuilder(_, _) {
    return const LoginPage(key: Key('login_page'));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: loginModuleProviders(context),
      child: const AppScaffold(body: LoginView(), toolbarHeight: 0),
    );
  }
}
