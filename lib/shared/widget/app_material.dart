import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/core/provider/locale_provider.dart';
import 'package:recetasperuanas/core/provider/theme_provider.dart';
import 'package:recetasperuanas/l10n/app_localizations.dart';

class AppMaterial extends StatelessWidget {
  final GoRouter appRouter;

  const AppMaterial({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, ThemeProvider>(
      builder: (_, localeProvider, themeProvider, __) {
        final isDark = themeProvider.themeMode == ThemeMode.dark;

        return AppColorScheme(
          brightness: isDark ? Brightness.dark : Brightness.light,
          platform: Theme.of(context).platform,
          child: MaterialApp.router(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.themeMode,
            title: 'App Cocinando',
            locale: localeProvider.locale,
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
