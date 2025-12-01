import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/config/color/app_color_scheme.dart';
import 'package:goncook/common/l10n/app_localizations.dart';
import 'package:goncook/core/bloc/locale_bloc.dart';
import 'package:goncook/core/bloc/theme_bloc.dart';

class AppMaterial extends StatelessWidget {
  final GoRouter appRouter;

  const AppMaterial({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, localeState) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            final locale = localeState is LocaleLoaded ? localeState.locale : const Locale('es');
            final themeMode = themeState is ThemeLoaded ? themeState.themeMode : ThemeMode.system;
            final isDark = themeMode == ThemeMode.dark;

            return AppColorScheme(
              brightness: isDark ? Brightness.dark : Brightness.light,
              platform: Theme.of(context).platform,
              child: MaterialApp.router(
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                themeMode: themeMode,
                title: 'CocinandoIA',
                locale: locale,
                debugShowCheckedModeBanner: false,
                routerConfig: appRouter,
                localizationsDelegates: _localizationsDelegates,
                supportedLocales: _supportedLocales,
              ),
            );
          },
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
