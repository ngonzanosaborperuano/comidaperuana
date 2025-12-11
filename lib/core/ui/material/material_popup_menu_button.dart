import 'package:flutter/material.dart';

/// Menú contextual Material con variantes texto e ícono.
class MaterialPopupMenuButton extends StatelessWidget {
  /// Crea un botón de menú con label textual.
  const MaterialPopupMenuButton.text({
    super.key,
    required this.items,
    required this.onSelected,
    this.buttonLabel = 'Actions',
    this.icon,
  }) : buttonIcon = null,
       size = null;

  /// Crea un botón de menú con ícono.
  const MaterialPopupMenuButton.icon({
    super.key,
    required this.items,
    required this.onSelected,
    required this.buttonIcon,
    this.size = 44,
  }) : buttonLabel = null,
       icon = null;

  /// Entradas del menú.
  final List<PopupMenuEntry<int>> items;

  /// Callback al seleccionar (índice).
  final ValueChanged<int> onSelected;

  /// Texto del botón (modo texto).
  final String? buttonLabel;

  /// Ícono del botón (modo ícono).
  final IconData? buttonIcon;

  /// Tamaño del botón en modo ícono.
  final double? size;

  /// Ícono opcional cuando se usa modo texto.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (buttonIcon != null) {
      return PopupMenuButton<int>(
        icon: Icon(buttonIcon, size: size),
        onSelected: onSelected,
        itemBuilder: (context) => items,
      );
    }

    return PopupMenuButton<int>(
      onSelected: onSelected,
      itemBuilder: (context) => items,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 6)],
          Text(buttonLabel ?? 'Actions'),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
