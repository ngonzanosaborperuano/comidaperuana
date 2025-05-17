import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/preferences/preferences.dart';
import 'package:recetasperuanas/modules/welcome/view/welcome_view.dart';

import 'package:recetasperuanas/shared/widget/app_scaffold.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  factory WelcomePage.routeBuilder(_, __) {
    return WelcomePage(key: const Key('welcome_page'));
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferencesHelper.instance.setBool(
      CacheConstants.welcome,
      value: true,
    );
    return AppScaffold(body: WelcomeView());
  }
}
