import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';

/// Selector segmentado nativo (UISegmentedControl).
class CupertinoNativeSegmentedControl extends StatelessWidget {
  /// Crea un control segmentado con etiquetas y cambio de índice.
  const CupertinoNativeSegmentedControl({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onValueChanged,
    this.color = CupertinoColors.activeBlue,
    this.height = 32,
    this.sfSymbols,
  });

  /// Etiquetas de los segmentos.
  final List<String> labels;

  /// Índice seleccionado.
  final int selectedIndex;

  /// Callback al cambiar.
  final ValueChanged<int> onValueChanged;

  /// Color de tinte.
  final Color color;

  /// Alto del control.
  final double height;

  /// Lista opcional de símbolos SF para cada segmento.
  final List<CNSymbol>? sfSymbols;

  @override
  Widget build(BuildContext context) {
    return CNSegmentedControl(
      labels: labels,
      selectedIndex: selectedIndex,
      onValueChanged: onValueChanged,
      color: color,
      height: height,
      sfSymbols: sfSymbols,
    );
  }
}
