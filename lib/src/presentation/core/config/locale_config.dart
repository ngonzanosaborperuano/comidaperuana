import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetasperuanas/src/presentation/core/bloc/locale_bloc.dart';
import 'package:recetasperuanas/src/shared/l10n/app_localizations.dart';

class LocaleConfig {
  static Widget buildWithLocale({required Widget child, required BuildContext context}) {
    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) {
        if (state is LocaleLoaded) {
          return MaterialApp(
            locale: state.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: child,
          );
        }
        return MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        );
      },
    );
  }

  static String getLocalizedString(BuildContext context, String key) {
    // Aquí puedes implementar la lógica para obtener strings localizados
    // basándose en el estado del LocaleBloc
    return key; // Placeholder por ahora
  }
}
