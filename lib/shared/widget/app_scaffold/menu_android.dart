import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/provider/pages_provider.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/app_scaffold/navigation_items_mixin.dart';

class MenuAndroid extends StatefulWidget {
  const MenuAndroid({super.key});

  @override
  State<MenuAndroid> createState() => _MenuAndroidState();
}

class _MenuAndroidState extends State<MenuAndroid> with NavigationItemsMixin {
  static const double _bottomNavIconSize = 30.0;
  static const double _shadowBlurRadius = 3.0;
  static const double _shadowSpreadRadius = 2.0;
  static const double _shadowOffsetY = 5.5;

  @override
  Widget build(BuildContext context) {
    return Consumer<PagesProvider>(
      builder: (BuildContext context, PagesProvider value, Widget? child) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: context.color.textSecondary,
                  boxShadow: [
                    BoxShadow(
                      color: context.color.menuActive,
                      blurRadius: _shadowBlurRadius,
                      spreadRadius: _shadowSpreadRadius,
                      offset: const Offset(0, _shadowOffsetY),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  backgroundColor: context.color.background,
                  selectedItemColor: context.color.textSecondary2,
                  unselectedItemColor: context.color.textSecondary,
                  currentIndex: value.selectPage,
                  iconSize: _bottomNavIconSize,
                  type: BottomNavigationBarType.fixed,
                  showUnselectedLabels: true,
                  showSelectedLabels: true,
                  enableFeedback: false,
                  items: buildAndroidNavigationItems(value.selectPage, context),
                  onTap: (index) {
                    context.read<PagesProvider>().togglePage(index);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
