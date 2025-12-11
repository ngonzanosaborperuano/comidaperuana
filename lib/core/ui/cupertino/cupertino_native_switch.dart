import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';

/// Interruptor nativo (UISwitch) listo para usar.
class CupertinoNativeSwitch extends StatelessWidget {
  /// Crea un switch con valor y callback.
  const CupertinoNativeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.color = CupertinoColors.activeBlue,
  });

  /// Estado actual.
  final bool value;

  /// Callback de cambio.
  final ValueChanged<bool> onChanged;

  /// Color de tinte.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CNSwitch(value: value, onChanged: onChanged, color: color);
  }
}
