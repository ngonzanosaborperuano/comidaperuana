import 'package:flutter/material.dart';
import 'package:goncook/src/presentation/welcome/view/welcome_view.dart';
import 'package:goncook/src/shared/storage/preferences/preferences.dart';
import 'package:goncook/src/shared/widget/app_scaffold/app_scaffold.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  factory WelcomePage.routeBuilder(_, _) {
    return const WelcomePage(key: Key('welcome_page'));
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferencesHelper.instance.setBool(CacheConstants.welcome, value: true);
    return const AppScaffold(body: WelcomeView());
  }
}
