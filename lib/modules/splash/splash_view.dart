import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/core/preferences/preferences.dart';
import 'package:recetasperuanas/core/provider/locale_provider.dart';
import 'package:recetasperuanas/core/provider/theme_provider.dart';
import 'package:recetasperuanas/core/secure_storage/securete_storage_service.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  factory SplashView.routeBuilder(_, __) {
    return SplashView(key: const Key('splash_page'));
  }

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward().whenComplete(() {
      checkLoginAndRedirect(context);
    });
  }

  Future<void> checkLoginAndRedirect(BuildContext context) async {
    try {
      final secureStorageService = SecurityStorageService();
      final user = await secureStorageService.loadCredentials();

      final isDark = SharedPreferencesHelper.instance.getBool(CacheConstants.darkMode);
      final isNotSpanish = SharedPreferencesHelper.instance.getBool(CacheConstants.spanish);

      if (!context.mounted) return;

      context.read<ThemeProvider>().toggleTheme(isDark);
      context.read<LocaleProvider>().setLocale(Locale(isNotSpanish ? 'en' : 'es'));

      final route = user != AuthUser.empty() ? Routes.home.description : Routes.login.description;
      _controller.reverse().whenComplete(() {
        context.go(route);
      });
    } catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      if (context.mounted) {
        context.go(Routes.login.description);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.textSecundary,
      body: Center(
        child: RotationTransition(
          turns: Tween(begin: 0.0, end: 0.025).animate(_animation),
          child: Image.asset('assets/img/logoOutName.png', width: 300, height: 300),
        ),
      ),
    );
  }
}
