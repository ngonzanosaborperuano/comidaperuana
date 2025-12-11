import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';

/// Slider nativo (UISlider) con controlador opcional.
class CupertinoNativeSlider extends StatelessWidget {
  /// Crea un slider nativo con valores mínimo/máximo y paso opcional.
  const CupertinoNativeSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.step,
    this.color = CupertinoColors.activeBlue,
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
  final Color color;

  /// Alto del control.
  final double height;

  /// Controlador imperativo.
  final CNSliderController? controller;

  @override
  Widget build(BuildContext context) {
    return CNSlider(
      value: value,
      min: min,
      max: max,
      step: step,
      onChanged: onChanged,
      color: color,
      height: height,
      controller: controller,
    );
  }
}

/// Controlador para modificar el slider de forma imperativa.
typedef CupertinoNativeSliderController = CNSliderController;
