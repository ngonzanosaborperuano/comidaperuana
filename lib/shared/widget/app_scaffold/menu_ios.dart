import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/provider/pages_provider.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/app_scaffold/navigation_items_mixin.dart';

class MenuIOS extends StatelessWidget with NavigationItemsMixin {
  static const double _shadowBlurRadius = 4.0;
  static const double _shadowSpreadRadius = 3.0;
  static const double _shadowOffsetY = 5.5;
  const MenuIOS({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PagesProvider>(
      builder: (BuildContext context, PagesProvider value, Widget? child) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: context.color.background,
              boxShadow: [
                BoxShadow(
                  color: context.color.menuActive,
                  blurRadius: _shadowBlurRadius,
                  spreadRadius: _shadowSpreadRadius,
                  offset: const Offset(0, _shadowOffsetY),
                ),
              ],
            ),
            child: SizedBox(
              height: kBottomNavigationBarHeight * 1.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildAppStoreStyleItems(value.selectPage, context),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildAppStoreStyleItems(int currentPage, BuildContext context) {
    final navigationItems = buildIOSNavigationItems(currentPage, context);

    return List.generate(navigationItems.length, (index) {
      final isSelected = currentPage == index;
      final item = navigationItems[index];

      return GestureDetector(
        onTap: () {
          context.read<PagesProvider>().togglePage(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              item.icon,
              const SizedBox(height: 4),
              if (item.label != null)
                Text(
                  item.label!,
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        isSelected
                            ? context.color.textSecondary2
                            : context.color.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
