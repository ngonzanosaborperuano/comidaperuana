import 'package:flutter/material.dart';

/// Slider Material con API alineada al slider Cupertino.
class MaterialSlider extends StatelessWidget {
  /// Crea un slider con valores mínimo/máximo y paso opcional.
  const MaterialSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 100,
    this.step,
    this.color,
    this.height = 44,
  });

  /// Valor actual.
  final double value;

  /// Valor mínimo.
  final double min;

  /// Valor máximo.
  final double max;

  /// Paso discreto (opcional). Si se define, calcula divisions.
  final double? step;

  /// Callback de cambio.
  final ValueChanged<double> onChanged;

  /// Color activo opcional.
  final Color? color;

  /// Alto sugerido (wrapper decorativo).
  final double height;

  @override
  Widget build(BuildContext context) {
    final divisions = step != null && step! > 0 ? ((max - min) / step!).round() : null;
    final activeColor = color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      height: height,
      child: Slider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        divisions: divisions,
        activeColor: activeColor,
        onChanged: onChanged,
      ),
    );
  }
}
