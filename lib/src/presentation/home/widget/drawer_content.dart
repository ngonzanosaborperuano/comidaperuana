import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/src/presentation/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/src/presentation/home/controller/home_controller.dart';
import 'package:recetasperuanas/src/presentation/home/widget/item_menu.dart' show ItemMenu;
import 'package:recetasperuanas/src/shared/constants/routes.dart' show Routes;
import 'package:recetasperuanas/src/shared/controller/base_controller.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key, required this.con});
  final HomeController con;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIOS) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ItemMenu(
            title: 'Dashboard',
            onTap: () {
              context.go(Routes.dashboard.description, extra: con.listTaskDashboard);
            },
          ),
          ItemMenu(
            title: context.loc.setting,
            onTap: () {
              context.go(Routes.setting.description);
            },
          ),
        ],
      );
    } else {
      return ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColorScheme.of(context).primary),
            child: Text(
              'Menú',
              style: TextStyle(color: AppColorScheme.of(context).secondary, fontSize: 24),
            ),
          ),

          ItemMenu(
            title: 'Dashboard',
            onTap: () {
              context.go(Routes.dashboard.description, extra: con.listTaskDashboard);
            },
          ),
          ItemMenu(
            title: context.loc.setting,
            onTap: () {
              context.go(Routes.setting.description);
            },
          ),
        ],
      );
    }
  }
}
