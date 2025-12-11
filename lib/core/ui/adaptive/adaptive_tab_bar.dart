import 'dart:io' show Platform;

import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:goncook/core/ui/cupertino/cupertino_native_tab_bar.dart';
import 'package:goncook/core/ui/material/material_tab_bar.dart';

/// Item para `AdaptiveTabBar`.
class AdaptiveTabBarItem {
  /// Crea un item adaptable.
  const AdaptiveTabBarItem({
    required this.label,
    required this.materialIcon,
    required this.cupertinoIcon,
    this.materialSelectedIcon,
    this.cupertinoSelectedIcon,
  });

  /// Texto del tab.
  final String label;

  /// Icono Material.
  final IconData materialIcon;

  /// Icono Cupertino (SF Symbol).
  final CNSymbol cupertinoIcon;

  /// Icono Material para seleccionado.
  final IconData? materialSelectedIcon;

  /// Icono Cupertino para seleccionado.
  final CNSymbol? cupertinoSelectedIcon;
}

/// Tab bar adaptable: usa `CNTabBar` en iOS y `NavigationBar` en otros.
class AdaptiveTabBar extends StatelessWidget {
  /// Crea una tab bar con items e índice actual.
  const AdaptiveTabBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  /// Items del tab bar.
  final List<AdaptiveTabBarItem> items;

  /// Índice seleccionado.
  final int currentIndex;

  /// Callback al seleccionar.
  final ValueChanged<int> onTap;

  bool get _isCupertino => !kIsWeb && Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    if (_isCupertino) {
      return CupertinoNativeTabBar(
        items: items.map((e) => CNTabBarItem(label: e.label, icon: e.cupertinoIcon)).toList(),
        currentIndex: currentIndex,
        onTap: onTap,
      );
    }

    return MaterialTabBar(
      items: items
          .map(
            (e) => MaterialTabBarItem(
              label: e.label,
              icon: e.materialIcon,
              selectedIcon: e.materialSelectedIcon,
            ),
          )
          .toList(),
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
