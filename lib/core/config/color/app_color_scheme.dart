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
    final inherited =
        context.dependOnInheritedWidgetOfExactType<AppColorScheme>();
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    final platform = Theme.of(context).platform;

    return inherited ??
        AppColorScheme(
          brightness: brightness,
          platform: platform,
          child: const SizedBox.shrink(),
        );
  }

  Color get primary {
    return brightness == Brightness.dark
        ? AppColors.primaryCopper
        : AppColors.white;
  }

  Color get secondary {
    return brightness != Brightness.dark
        ? AppColors.primaryCopper
        : AppColors.white;
  }

  Color get success {
    return brightness == Brightness.dark
        ? AppColors.secondary
        : AppColors.success;
  }

  Color get errorPrimary {
    return brightness != Brightness.dark
        ? AppColors.secondaryRed
        : AppColors.white;
  }

  Color get errorSecundary {
    return brightness == Brightness.dark
        ? AppColors.secondaryRed
        : AppColors.white;
  }

  Color get textPrimary {
    return brightness == Brightness.dark
        ? AppColors.white
        : AppColors.blackColor;
  }

  Color get textSecundary {
    return brightness != Brightness.dark
        ? AppColors.white
        : AppColors.blackColor;
  }

  Color get warnnig {
    return brightness != Brightness.dark
        ? AppColors.warningBackground
        : AppColors.warning;
  }

  @override
  bool updateShouldNotify(covariant AppColorScheme oldWidget) {
    return brightness != oldWidget.brightness || platform != oldWidget.platform;
  }
}
