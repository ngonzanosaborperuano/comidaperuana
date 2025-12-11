import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:goncook/core/ui/cupertino/cupertino_native_switch.dart';
import 'package:goncook/core/ui/material/material_switch.dart';

/// Switch adaptable: usa `CNSwitch` en iOS y `Switch` Material en otros.
class AdaptiveSwitch extends StatelessWidget {
  /// Crea un switch adaptable.
  const AdaptiveSwitch({super.key, required this.value, required this.onChanged, this.color});

  /// Estado actual.
  final bool value;

  /// Callback de cambio.
  final ValueChanged<bool> onChanged;

  /// Color de tinte.
  final Color? color;

  bool get _isCupertino => !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    if (_isCupertino) {
      return CupertinoNativeSwitch(
        value: value,
        onChanged: onChanged,
        color: color ?? CupertinoTheme.of(context).primaryColor,
      );
    }

    return MaterialSwitch(value: value, onChanged: onChanged, color: color);
  }
}
