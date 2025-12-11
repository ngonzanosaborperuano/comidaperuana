import 'package:flutter/material.dart';

/// Tab bar Material usando `NavigationBar` (M3).
class MaterialTabBar extends StatelessWidget {
  /// Crea una tab bar con destinos e índice actual.
  const MaterialTabBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  /// Destinos del tab bar.
  final List<MaterialTabBarItem> items;

  /// Índice seleccionado.
  final int currentIndex;

  /// Callback al seleccionar.
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        for (final item in items)
          NavigationDestination(
            icon: Icon(item.icon),
            label: item.label,
            selectedIcon: item.selectedIcon != null ? Icon(item.selectedIcon) : null,
          ),
      ],
    );
  }
}

/// Item para `MaterialTabBar`.
class MaterialTabBarItem {
  /// Crea un item de tab.
  const MaterialTabBarItem({required this.label, required this.icon, this.selectedIcon});

  /// Texto del tab.
  final String label;

  /// Icono principal.
  final IconData icon;

  /// Icono opcional para estado seleccionado.
  final IconData? selectedIcon;
}
