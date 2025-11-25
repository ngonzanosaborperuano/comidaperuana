import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/src/shared/constants/routes.dart';
import 'package:goncook/src/shared/storage/preferences/preferences.dart';
import 'package:goncook/src/src.dart';
import 'package:logging/logging.dart';

// GoRoute(
//   path: '/welcome',
//   name: 'welcome',
//   builder: (context, state) {
//     final id = state.uri.queryParameters['id'];
//     return WelcomeScreen(id: id);
//   },
// ),

// https://ricope-e01a994cf2ab.herokuapp.com/welcome?id=123
// https://ricope-e01a994cf2ab.herokuapp.com/welcome?ref=abc

final appRouter = GoRouter(
  initialLocation: SharedPreferencesHelper.instance.getBool(CacheConstants.welcome)
      ? Routes.splash.description
      : Routes.welcome.description,
  observers: [LoggingObserver()],
  routes: [
    GoRoute(path: Routes.splash.description, builder: SplashView.routeBuilder),
    GoRoute(path: Routes.welcome.description, builder: WelcomePage.routeBuilder),
    GoRoute(path: Routes.login.description, builder: LoginPage.routeBuilder),
    GoRoute(path: Routes.register.description, builder: RegisterPage.routeBuilder),
    GoRoute(
      path: Routes.home.description,
      builder: HomePage.routeBuilder,
      routes: [
        GoRoute(path: Routes.setting.endpoint, builder: SettingPage.routeBuilder),
        GoRoute(path: Routes.dashboard.endpoint, builder: DashboardPage.routeBuilder),
        GoRoute(
          path: Routes.payuCheckout.endpoint,
          name: Routes.payuCheckout.description,
          builder: PayUCheckoutWebPage.routeBuilder,
        ),
      ],
    ),
  ],
  redirect: (context, state) {
    final uri = state.uri;
    final path = uri.path;

    if (path != '/' && path.endsWith('/')) {
      final cleaned = path.substring(0, path.length - 1);
      return uri.replace(path: cleaned).toString();
    }
    return null;
  },
);

class LoggingObserver extends NavigatorObserver {
  final _logger = Logger('NavigatorObserver');
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logger.info('didPush from ${previousRoute?.settings.name} to ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logger.info('didPop from ${route.settings.name} to ${previousRoute?.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logger.info('didRemove ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _logger.info('didReplace from ${oldRoute?.settings.name} to ${newRoute?.settings.name}');
  }
}
