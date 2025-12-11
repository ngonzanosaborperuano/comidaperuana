import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:goncook/core/ui/cupertino/cupertino_native_segmented_control.dart';
import 'package:goncook/core/ui/material/material_segmented_control.dart';

/// Selector segmentado adaptable por plataforma.
class AdaptiveSegmentedControl extends StatelessWidget {
  /// Crea un control segmentado con labels y selección por índice.
  const AdaptiveSegmentedControl({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onValueChanged,
    this.cupertinoColor,
    this.cupertinoHeight = 32,
  });

  /// Etiquetas de los segmentos.
  final List<String> labels;

  /// Índice seleccionado.
  final int selectedIndex;

  /// Callback al cambiar.
  final ValueChanged<int> onValueChanged;

  /// Color para iOS.
  final Color? cupertinoColor;

  /// Alto para iOS.
  final double cupertinoHeight;

  bool get _isCupertino => !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    if (_isCupertino) {
      return CupertinoNativeSegmentedControl(
        labels: labels,
        selectedIndex: selectedIndex,
        onValueChanged: onValueChanged,
        color: cupertinoColor ?? CupertinoTheme.of(context).primaryColor,
        height: cupertinoHeight,
      );
    }

    return MaterialSegmentedControl(
      labels: labels,
      selectedIndex: selectedIndex,
      onValueChanged: onValueChanged,
    );
  }
}
