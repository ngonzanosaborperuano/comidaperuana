import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/config/config.dart';

class AppColorScheme extends InheritedWidget {
  final Brightness brightness;
  final TargetPlatform platform;

  const AppColorScheme({
    super.key,
    required super.child,
    required this.brightness,
    required this.platform,
  });

  static AppColorScheme of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<AppColorScheme>();
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;

    final platform = Theme.of(context).platform;

    return inherited ??
        AppColorScheme(brightness: brightness, platform: platform, child: const SizedBox.shrink());
  }

  // === COLORES PRINCIPALES ===
  Color get buttonPrimary {
    return brightness == Brightness.dark ? AppColors.primary1 : AppColors.primary1;
  }

  Color get background {
    return brightness == Brightness.dark ? AppColors.backgroundDark : AppColors.background;
  }

  Color get backgroundCard {
    return brightness == Brightness.dark ? AppColors.backgroundCardDark : AppColors.backgroundCard;
  }

  Color get textSecondary {
    return brightness == Brightness.dark ? AppColors.text2 : AppColors.text2;
  }

  Color get textSecondary2 {
    return brightness == Brightness.dark ? AppColors.textSecondaryDark : AppColors.textSecondary;
  }

  Color get textSecondary2Invert {
    return brightness == Brightness.dark ? AppColors.textSecondary : AppColors.textSecondaryDark;
  }

  Color get text {
    return brightness == Brightness.dark ? AppColors.textDark : AppColors.text;
  }

  Color get textNormal {
    return brightness == Brightness.dark ? AppColors.textDark : AppColors.textDark;
  }

  Color get error {
    return brightness == Brightness.dark ? AppColors.error : AppColors.error;
  }

  Color get errorText {
    return brightness == Brightness.dark ? AppColors.errorText : AppColors.errorText;
  }

  Color get border {
    return brightness == Brightness.dark ? AppColors.slate700 : AppColors.text2;
  }

  Color get primary {
    return brightness == Brightness.dark ? AppColors.slate800 : AppColors.white;
  }

  Color get secondary {
    return brightness == Brightness.dark ? AppColors.primary1 : AppColors.slate700;
  }

  Color get surface {
    return brightness == Brightness.dark ? AppColors.slate900 : AppColors.backgroundCard;
  }

  // === COLORES DE TEXTO ===

  Color get textOnPrimary {
    return brightness == Brightness.dark ? AppColors.slate900 : AppColors.white;
  }

  // === COLORES DE MENÚ ===

  Color get menuActive {
    return brightness == Brightness.dark ? AppColors.primary1 : AppColors.slate700;
  }

  Color get menuInactive {
    return brightness == Brightness.dark ? AppColors.slate500 : AppColors.slate400;
  }

  Color get menuBackground {
    return brightness == Brightness.dark ? AppColors.slate800 : AppColors.slate200;
  }

  // === COLORES DE ESTADO ===

  Color get success {
    return brightness == Brightness.dark ? AppColors.emerald200 : AppColors.emerald700;
  }

  Color get successBackground {
    return brightness == Brightness.dark ? AppColors.emerald900 : AppColors.emerald50;
  }

  Color get errorBackground {
    return brightness == Brightness.dark ? AppColors.red800 : AppColors.red50;
  }

  Color get warning {
    return brightness == Brightness.dark ? AppColors.yellow400 : AppColors.amber700;
  }

  Color get warningBackground {
    return brightness == Brightness.dark ? AppColors.amber900 : AppColors.yellow100;
  }

  Color get info {
    return brightness == Brightness.dark ? AppColors.slate400 : AppColors.slate500;
  }

  // === COLORES DE BORDES ===

  Color get borderLight {
    return brightness == Brightness.dark ? AppColors.slate800 : AppColors.slate200;
  }

  // === COLORES DE SOMBRAS ===

  Color get shadow {
    return brightness == Brightness.dark
        ? AppColors.text2.withValues(alpha: 0.5)
        : AppColors.slate900.withValues(alpha: 0.1);
  }

  Color get elevation {
    return brightness == Brightness.dark ? AppColors.slate800 : AppColors.white;
  }

  // === GRADIENTES ===

  LinearGradient get primaryGradient {
    return brightness == Brightness.dark ? AppColors.darkModeLinear : AppColors.orangeToBrownLinear;
  }

  LinearGradient get successGradient {
    return AppColors.successLinear;
  }

  LinearGradient get warmGradient {
    return AppColors.warmLinear;
  }

  LinearGradient get subscriptionGradient {
    return AppColors.orangeToBrownLinear;
  }

  // === PROPIEDADES ADICIONALES PARA COMPATIBILIDAD ===

  @override
  bool updateShouldNotify(covariant AppColorScheme oldWidget) {
    return brightness != oldWidget.brightness || platform != oldWidget.platform;
  }
}
