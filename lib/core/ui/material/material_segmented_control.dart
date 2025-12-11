import 'package:flutter/material.dart';

/// Selector segmentado Material usando `SegmentedButton`.
class MaterialSegmentedControl extends StatelessWidget {
  /// Crea un control segmentado con labels y selección por índice.
  const MaterialSegmentedControl({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onValueChanged,
  });

  /// Etiquetas de los segmentos.
  final List<String> labels;

  /// Índice seleccionado.
  final int selectedIndex;

  /// Callback al cambiar.
  final ValueChanged<int> onValueChanged;

  @override
  Widget build(BuildContext context) {
    final segments = <ButtonSegment<int>>[
      for (var i = 0; i < labels.length; i++) ButtonSegment<int>(value: i, label: Text(labels[i])),
    ];

    return SegmentedButton<int>(
      segments: segments,
      selected: {selectedIndex},
      onSelectionChanged: (set) {
        if (set.isNotEmpty) onValueChanged(set.first);
      },
    );
  }
}
