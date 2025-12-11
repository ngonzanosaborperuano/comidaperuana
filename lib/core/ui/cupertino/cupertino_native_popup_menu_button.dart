import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';

/// Menú contextual nativo listo para usar.
class CupertinoNativePopupMenuButton extends StatelessWidget {
  /// Crea un botón de menú con label textual.
  const CupertinoNativePopupMenuButton.text({
    super.key,
    required this.items,
    required this.onSelected,
    this.buttonLabel = 'Actions',
    this.buttonStyle = CNButtonStyle.bordered,
    this.size,
  }) : buttonIcon = null;

  /// Crea un botón de menú con ícono SF.
  const CupertinoNativePopupMenuButton.icon({
    super.key,
    required this.items,
    required this.onSelected,
    required this.buttonIcon,
    this.buttonStyle = CNButtonStyle.bordered,
    this.size = 44,
  }) : buttonLabel = null;

  /// Ítems del menú.
  final List<CNPopupMenuEntry> items;

  /// Callback de selección (índice).
  final ValueChanged<int> onSelected;

  /// Label del botón (modo texto).
  final String? buttonLabel;

  /// Ícono del botón (modo ícono).
  final CNSymbol? buttonIcon;

  /// Estilo del botón.
  final CNButtonStyle buttonStyle;

  /// Tamaño del botón (modo ícono) o altura (modo texto).
  final double? size;

  @override
  Widget build(BuildContext context) {
    if (buttonIcon != null) {
      return CNPopupMenuButton.icon(
        items: items,
        onSelected: onSelected,
        buttonIcon: buttonIcon!,
        size: size ?? 44,
      );
    }

    return CNPopupMenuButton(
      items: items,
      onSelected: onSelected,
      buttonLabel: buttonLabel ?? 'Actions',
      buttonStyle: buttonStyle,
    );
  }
}

/// Item del menú contextual nativo.
typedef CupertinoNativePopupMenuItem = CNPopupMenuItem;

/// Separador del menú contextual nativo.
typedef CupertinoNativePopupMenuDivider = CNPopupMenuDivider;
