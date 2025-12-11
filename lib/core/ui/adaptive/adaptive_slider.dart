import 'dart:io' show Platform;

import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:goncook/core/ui/cupertino/cupertino_native_slider.dart';
import 'package:goncook/core/ui/material/material_slider.dart';

/// Slider adaptable: usa `CNSlider` en iOS y `Slider` Material en otros.
class AdaptiveSlider extends StatelessWidget {
  /// Crea un slider adaptable.
  const AdaptiveSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.step,
    this.color,
    this.height = 44,
    this.controller,
  });

  /// Valor actual.
  final double value;

  /// Valor mínimo.
  final double min;

  /// Valor máximo.
  final double max;

  /// Paso discreto (opcional).
  final double? step;

  /// Callback de cambio.
  final ValueChanged<double> onChanged;

  /// Color de tinte.
  final Color? color;

  /// Alto del control.
  final double height;

  /// Controlador para iOS.
  final CNSliderController? controller;

  bool get _isCupertino => !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    if (_isCupertino) {
      return CupertinoNativeSlider(
        value: value,
        min: min,
        max: max,
        step: step,
        onChanged: onChanged,
        color: color ?? CupertinoTheme.of(context).primaryColor,
        height: height,
        controller: controller,
      );
    }

    return MaterialSlider(
      value: value,
      min: min,
      max: max,
      step: step,
      onChanged: onChanged,
      color: color,
      height: height,
    );
  }
}
