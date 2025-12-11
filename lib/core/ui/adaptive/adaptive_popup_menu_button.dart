import 'dart:io' show Platform;

import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goncook/core/ui/cupertino/cupertino_native_popup_menu_button.dart';

/// Entrada genérica para menú adaptable.
class AdaptiveMenuItem {
  /// Crea un ítem (o divider si `isDivider` es true).
  const AdaptiveMenuItem({
    required this.label,
    this.materialIcon,
    this.cupertinoIcon,
    this.enabled = true,
    this.isDivider = false,
  });

  /// Texto del ítem.
  final String label;

  /// Ícono Material opcional.
  final IconData? materialIcon;

  /// SF Symbol opcional.
  final CNSymbol? cupertinoIcon;

  /// Estado habilitado.
  final bool enabled;

  /// Si es un separador.
  final bool isDivider;
}

/// Menú contextual que usa Material en Android/Web y Cupertino Native en iOS.
class AdaptivePopupMenuButton extends StatelessWidget {
  /// Variante de texto.
  const AdaptivePopupMenuButton.text({
    super.key,
    required this.items,
    required this.onSelected,
    this.buttonLabel = 'Actions',
    this.materialIcon,
  }) : buttonIcon = null,
       buttonSymbol = null,
       size = null;

  /// Variante con ícono.
  const AdaptivePopupMenuButton.icon({
    super.key,
    required this.items,
    required this.onSelected,
    this.buttonIcon,
    this.buttonSymbol,
    this.size = 44,
  }) : buttonLabel = null,
       materialIcon = null;

  /// Ítems genéricos.
  final List<AdaptiveMenuItem> items;

  /// Callback de selección (índice).
  final ValueChanged<int> onSelected;

  /// Label en modo texto.
  final String? buttonLabel;

  /// Ícono Material en modo texto.
  final IconData? materialIcon;

  /// Ícono Material en modo ícono.
  final IconData? buttonIcon;

  /// SF Symbol en modo ícono.
  final CNSymbol? buttonSymbol;

  /// Tamaño en modo ícono.
  final double? size;

  bool get _isCupertino => !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    if (_isCupertino) {
      final cupertinoItems = _buildCupertinoItems();
      if (buttonSymbol != null) {
        return CupertinoNativePopupMenuButton.icon(
          items: cupertinoItems,
          onSelected: onSelected,
          buttonIcon: buttonSymbol!,
          size: size,
        );
      }
      return CupertinoNativePopupMenuButton.text(
        items: cupertinoItems,
        onSelected: onSelected,
        buttonLabel: buttonLabel ?? 'Actions',
      );
    }

    return PopupMenuButton<int>(
      icon: buttonIcon != null ? Icon(buttonIcon, size: size) : null,
      onSelected: onSelected,
      itemBuilder: (_) => _buildMaterialItems(),
      child: buttonIcon == null && buttonLabel != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (materialIcon != null) ...[
                  Icon(materialIcon, size: 18),
                  const SizedBox(width: 6),
                ],
                Text(buttonLabel!),
                const Icon(Icons.arrow_drop_down),
              ],
            )
          : null,
    );
  }

  List<CNPopupMenuEntry> _buildCupertinoItems() {
    final result = <CNPopupMenuEntry>[];
    for (final item in items) {
      if (item.isDivider) {
        result.add(const CNPopupMenuDivider());
        continue;
      }
      result.add(
        CNPopupMenuItem(label: item.label, icon: item.cupertinoIcon, enabled: item.enabled),
      );
    }
    return result;
  }

  List<PopupMenuEntry<int>> _buildMaterialItems() {
    final result = <PopupMenuEntry<int>>[];
    var idx = 0;
    for (final item in items) {
      if (item.isDivider) {
        result.add(const PopupMenuDivider());
        continue;
      }
      result.add(
        PopupMenuItem<int>(
          value: idx,
          enabled: item.enabled,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.materialIcon != null) ...[
                Icon(item.materialIcon, size: 18),
                const SizedBox(width: 6),
              ],
              Text(item.label),
            ],
          ),
        ),
      );
      idx++;
    }
    return result;
  }
}
