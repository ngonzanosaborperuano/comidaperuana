import 'package:flutter/widgets.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/core/preferences/preferences.dart';
import 'package:recetasperuanas/core/router/router.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

final appRouter = GoRouter(
  initialLocation:
      SharedPreferencesHelper.instance.getBool(CacheConstants.welcome)
          ? Routes.splash.description
          : Routes.welcome.description,
  observers: [LoggingObserver()],
  routes: [
    GoRoute(path: Routes.splash.description, builder: SplashView.routeBuilder),
    GoRoute(
      path: Routes.welcome.description,
      builder: WelcomePage.routeBuilder,
    ),
    GoRoute(path: Routes.login.description, builder: LoginPage.routeBuilder),
    GoRoute(
      path: Routes.register.description,
      builder: RegisterPage.routeBuilder,
    ),

    GoRoute(
      path: Routes.home.description,
      builder: HomePage.routeBuilder,
      routes: [
        GoRoute(
          path: Routes.setting.endpoint,
          builder: SettingPage.routeBuilder,
        ),
        GoRoute(
          path: Routes.dashboard.endpoint,
          builder: DashboardPage.routeBuilder,
        ),
      ],
    ),
  ],
);

class LoggingObserver extends NavigatorObserver {
  final _logger = Logger('NavigatorObserver');
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logger.info(
      'didPush from ${previousRoute?.settings.name} to ${route.settings.name}',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logger.info(
      'didPop from ${route.settings.name} to ${previousRoute?.settings.name}',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logger.info('didRemove ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _logger.info(
      'didReplace from ${oldRoute?.settings.name} to ${newRoute?.settings.name}',
    );
  }
}
