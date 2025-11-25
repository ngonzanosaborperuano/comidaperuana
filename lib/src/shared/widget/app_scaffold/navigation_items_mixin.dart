import 'package:flutter/material.dart';
import 'package:goncook/src/shared/controller/base_controller.dart';
import 'package:goncook/src/shared/widget/app_scaffold/shared_icon_menu.dart';

/// Mixin que proporciona métodos compartidos para construir items de navegación
/// tanto para Android como para iOS
mixin NavigationItemsMixin {
  /// Construye la lista de items de navegación para Android
  List<BottomNavigationBarItem> buildAndroidNavigationItems(int currentPage, BuildContext context) {
    return [
      _buildNavigationItem(
        iconPath: 'assets/svg/home.svg',
        label: context.loc.home,
        isSelected: currentPage == 0,
      ),
      _buildNavigationItem(
        iconPath: 'assets/svg/analysis.svg',
        label: context.loc.analysis,
        isSelected: currentPage == 1,
      ),
      _buildNavigationItem(
        iconPath: 'assets/svg/plan.svg',
        label: context.loc.plan,
        isSelected: currentPage == 2,
      ),
      _buildNavigationItem(
        iconPath: 'assets/svg/profile.svg',
        label: context.loc.profile,
        isSelected: currentPage == 3,
      ),
    ];
  }

  /// Construye la lista de items de navegación para iOS
  List<BottomNavigationBarItem> buildIOSNavigationItems(int currentPage, [BuildContext? context]) {
    return [
      _buildIOSNavigationItem(
        iconPath: 'assets/svg/home.svg',
        isSelected: currentPage == 0,
        label: context?.loc.home,
      ),
      _buildIOSNavigationItem(
        iconPath: 'assets/svg/analysis.svg',
        isSelected: currentPage == 1,
        label: context?.loc.analysis,
      ),
      _buildIOSNavigationItem(
        iconPath: 'assets/svg/plan.svg',
        isSelected: currentPage == 2,
        label: context?.loc.plan,
      ),
      _buildIOSNavigationItem(
        iconPath: 'assets/svg/profile.svg',
        isSelected: currentPage == 3,
        label: context?.loc.profile,
      ),
    ];
  }

  /// Construye un item de navegación para Android con label
  BottomNavigationBarItem _buildNavigationItem({
    required String iconPath,
    required String label,
    required bool isSelected,
  }) {
    return BottomNavigationBarItem(
      icon: SharedIconMenu(isSelected: isSelected, path: iconPath),
      label: label,
    );
  }

  /// Construye un item de navegación para iOS sin label
  BottomNavigationBarItem _buildIOSNavigationItem({
    required String iconPath,
    required bool isSelected,
    String? label,
  }) {
    return BottomNavigationBarItem(
      icon: SharedIconMenu(isSelected: isSelected, path: iconPath),
      label: label,
    );
  }
}
