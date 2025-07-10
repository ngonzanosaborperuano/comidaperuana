import 'dart:io';

import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = _getDeviceLocale();

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['en', 'es'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }

  // Detecta automáticamente el idioma del dispositivo
  static Locale _getDeviceLocale() {
    final deviceLocale = Platform.localeName;
    final languageCode = deviceLocale.split('_')[0];

    // Si el idioma del dispositivo es soportado, lo usa; si no, usa español por defecto
    if (['en', 'es'].contains(languageCode)) {
      return Locale(languageCode);
    }

    return const Locale('es'); // Idioma por defecto
  }
}
