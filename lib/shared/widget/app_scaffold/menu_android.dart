import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetasperuanas/core/bloc/pages_bloc.dart';
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
    return BlocBuilder<PagesBloc, PagesState>(
      builder: (BuildContext context, PagesState state) {
        final selectedPage = state is PagesLoaded ? state.selectedPage : 0;
        return Container(
          decoration: BoxDecoration(
            color: context.color.backgroundCard,
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
            backgroundColor: context.color.backgroundCard,
            selectedItemColor: context.color.textSecondary2,
            unselectedItemColor: context.color.textSecondary,
            currentIndex: selectedPage,
            iconSize: _bottomNavIconSize,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            enableFeedback: false,
            items: buildAndroidNavigationItems(selectedPage, context),
            onTap: (index) {
              context.read<PagesBloc>().add(PageChanged(index));
            },
          ),
        );
      },
    );
  }
}
