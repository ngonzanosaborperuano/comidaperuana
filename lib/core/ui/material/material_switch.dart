import 'package:flutter/material.dart';

/// Interruptor Material alineado a la API de `CupertinoNativeSwitch`.
class MaterialSwitch extends StatelessWidget {
  /// Crea un switch con valor y callback.
  const MaterialSwitch({super.key, required this.value, required this.onChanged, this.color});

  /// Estado actual.
  final bool value;

  /// Callback de cambio.
  final ValueChanged<bool> onChanged;

  /// Color activo opcional.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: color ?? Theme.of(context).colorScheme.primary,
    );
  }
}
