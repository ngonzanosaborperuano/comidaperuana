import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/core/preferences/preferences.dart';
import 'package:recetasperuanas/core/provider/locale_provider.dart';
import 'package:recetasperuanas/core/provider/theme_provider.dart';
import 'package:recetasperuanas/core/secure_storage/securete_storage_service.dart';
import 'package:recetasperuanas/modules/login/widget/logo_widget.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  factory SplashView.routeBuilder(_, _) {
    return const SplashView(key: Key('splash_page'));
  }

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
      vsync: this,
    );

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
      backgroundColor: context.color.background,
      body: Hero(
        tag: 'logo',
        child: Center(
          child: Transform.scale(
            scale: 1.5, // Más grande para splash
            child: const LogoWidget(),
          ),
        ),
      ),
    );
  }
}
