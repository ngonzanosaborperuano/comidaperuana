import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/core/preferences/preferences.dart';
import 'package:recetasperuanas/core/provider/locale_provider.dart';
import 'package:recetasperuanas/core/provider/theme_provider.dart';
import 'package:recetasperuanas/core/secure_storage/securete_storage_service.dart';
import 'package:recetasperuanas/shared/widget/app_scaffold.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  factory SplashView.routeBuilder(_, __) {
    return SplashView(key: const Key('splash_page'));
  }

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // Mover lógica aquí evita múltiples ejecuciones por hot reload o rebuilds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

      final route =
          user != AuthUser.empty() ? Routes.home.description : Routes.login.description; //login
      context.go(route);
    } catch (e, stackTrace) {
      debugPrint('Error en checkLoginAndRedirect: $e');
      debugPrintStack(stackTrace: stackTrace);
      if (context.mounted) {
        context.go(Routes.login.description); // Fallback por si algo falla
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(body: Center(child: CircularProgressIndicator.adaptive()));
  }
}
