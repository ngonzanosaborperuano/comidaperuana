import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  ThemeMode _themeMode = _getDeviceTheme();

  ThemeProvider() {
    // Escuchar cambios en el tema del sistema
    WidgetsBinding.instance.addObserver(this);
  }

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  // Detecta automáticamente el tema del dispositivo
  static ThemeMode _getDeviceTheme() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    switch (brightness) {
      case Brightness.dark:
        return ThemeMode.dark;
      case Brightness.light:
        return ThemeMode.light;
    }
  }

  // Escucha cambios en el tema del sistema
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    // Solo actualizar si estamos siguiendo el tema del sistema
    if (_themeMode == ThemeMode.system) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
