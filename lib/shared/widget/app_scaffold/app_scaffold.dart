import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/provider/pages_provider.dart';
import 'package:recetasperuanas/modules/setting/view/setting_page.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/app_scaffold/menu_android.dart';
import 'package:recetasperuanas/shared/widget/app_scaffold/menu_ios.dart';
import 'package:recetasperuanas/shared/widget/app_scaffold/page_home_android.dart';
import 'package:recetasperuanas/shared/widget/app_scaffold/page_home_ios.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({
    required this.body,
    this.onBackPressed,
    this.title,
    super.key,
    this.toolbarHeight = kToolbarHeight,
    this.onPressed,
    this.showMenu = false,
  });

  final Widget? title;
  final Widget body;
  final VoidCallback? onBackPressed;
  final double toolbarHeight;
  final void Function()? onPressed;
  final bool showMenu;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return isIOS
        ? _buildCupertinoScaffold(context)
        : _buildMaterialScaffold(context);
  }

  Widget _buildCupertinoScaffold(BuildContext context) {
    final List<Widget> pagesIOS = [
      PageHomeIOS(widget: widget),
      const SettingPage(),
    ];
    return ChangeNotifierProvider<PagesProvider>(
      create: (BuildContext context) => PagesProvider(),
      child: Consumer<PagesProvider>(
        builder: (BuildContext context, PagesProvider value, Widget? child) {
          return CupertinoPageScaffold(
            backgroundColor: context.color.background,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned.fill(
                  top: widget.toolbarHeight,
                  child: IndexedStack(
                    index: value.selectPage,
                    children: pagesIOS,
                  ),
                ),
                if (widget.showMenu) ...[const MenuIOS()],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMaterialScaffold(BuildContext context) {
    final List<Widget> pageAndroid = [
      PageHomeAndroid(widget: widget),
      const SettingPage(),
    ];
    return ChangeNotifierProvider<PagesProvider>(
      create: (BuildContext context) => PagesProvider(),
      child: Consumer<PagesProvider>(
        builder: (BuildContext context, PagesProvider value, Widget? child) {
          return Scaffold(
            backgroundColor: context.color.background,
            body: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned.fill(
                  top: widget.toolbarHeight,
                  child: IndexedStack(
                    index: value.selectPage,
                    children: pageAndroid,
                  ),
                ),
                if (widget.showMenu) ...[const MenuAndroid()],
              ],
            ),
          );
        },
      ),
    );
  }
}
