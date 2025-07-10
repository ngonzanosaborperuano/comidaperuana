import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/core/config/config.dart';
import 'package:recetasperuanas/core/provider/locale_provider.dart';
import 'package:recetasperuanas/core/provider/theme_provider.dart';
import 'package:recetasperuanas/l10n/app_localizations.dart';

class AppCupertino extends StatelessWidget {
  final GoRouter appRouter;

  const AppCupertino({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, ThemeProvider>(
      builder: (_, localeProvider, themeProvider, __) {
        final isDark = themeProvider.themeMode == ThemeMode.dark;

        return AppColorScheme(
          brightness: isDark ? Brightness.dark : Brightness.light,
          platform: defaultTargetPlatform,
          child: CupertinoApp.router(
            title: 'App Task',
            locale: localeProvider.locale,
            theme: CupertinoThemeData(
              brightness: isDark ? Brightness.dark : Brightness.light,
              primaryColor: AppColors.primary1,
              scaffoldBackgroundColor:
                  isDark ? CupertinoColors.black : CupertinoColors.systemGroupedBackground,
              textTheme: CupertinoTextThemeData(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: isDark ? CupertinoColors.white : AppColors.slate800,
                ),
                navTitleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? CupertinoColors.white : AppColors.white,
                ),
                navLargeTitleTextStyle: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: isDark ? CupertinoColors.white : AppColors.primary1,
                ),
                actionTextStyle: TextStyle(
                  color: isDark ? CupertinoColors.activeOrange : AppColors.primary1,
                ),
              ),
            ),
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,
            localizationsDelegates: _localizationsDelegates,
            supportedLocales: _supportedLocales,
          ),
        );
      },
    );
  }

  static const _localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const _supportedLocales = [Locale('en'), Locale('es')];
}
