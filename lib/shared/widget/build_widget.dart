import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';

import 'package:recetasperuanas/core/config/config.dart';
import 'package:recetasperuanas/core/provider/locale_provider.dart';
import 'package:recetasperuanas/core/provider/theme_provider.dart';
import 'package:recetasperuanas/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

Widget buildAndroidScreen(BuildContext context, GoRouter appRouter) {
  return Consumer2<LocaleProvider, ThemeProvider>(
    builder: (
      _,
      LocaleProvider localeProvider,
      ThemeProvider themeProvider,
      __,
    ) {
      final isDark = themeProvider.themeMode == ThemeMode.dark;
      return AppColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        platform: defaultTargetPlatform,
        child: MaterialApp.router(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeProvider.themeMode,
          title: 'App Task',
          locale: localeProvider.locale,
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
        ),
      );
    },
  );
}

Widget buildiOSScreen(BuildContext context, GoRouter appRouter) {
  return Consumer2<LocaleProvider, ThemeProvider>(
    builder: (
      _,
      LocaleProvider localeProvider,
      ThemeProvider themeProvider,
      __,
    ) {
      final isDark = themeProvider.themeMode == ThemeMode.dark;

      return AppColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        platform: defaultTargetPlatform,
        child: CupertinoApp.router(
          title: 'App Task',
          locale: localeProvider.locale,
          theme: CupertinoThemeData(
            brightness: isDark ? Brightness.dark : Brightness.light,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor:
                isDark
                    ? CupertinoColors.black
                    : CupertinoColors.systemGroupedBackground,
            textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: isDark ? CupertinoColors.white : AppColors.primaryText,
              ),
              navTitleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? CupertinoColors.white : AppColors.white,
              ),
              navLargeTitleTextStyle: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: isDark ? CupertinoColors.white : AppColors.primary,
              ),
              actionTextStyle: TextStyle(
                color:
                    isDark ? CupertinoColors.activeOrange : AppColors.primary,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
        ),
      );
    },
  );
}

Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates = const [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];
Iterable<Locale> supportedLocales = const [Locale('en'), Locale('es')];
