import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/provider/pages_provider.dart';
import 'package:recetasperuanas/modules/setting/view/setting_page.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/app_scaffold/menu_android.dart';
import 'package:recetasperuanas/shared/widget/app_scaffold/menu_ios.dart' show MenuIOS;
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

    return isIOS ? _buildCupertinoScaffold(context) : _buildMaterialScaffold(context);
  }

  Widget _buildCupertinoScaffold(BuildContext context) {
    final List<Widget> pagesIOS = [PageHomeIOS(widget: widget), const SettingPage()];
    return ChangeNotifierProvider<PagesProvider>(
      create: (BuildContext context) => PagesProvider(),
      child: Consumer<PagesProvider>(
        builder: (BuildContext context, PagesProvider value, Widget? child) {
          if (widget.showMenu) {
            return CupertinoTabScaffold(
              backgroundColor: context.color.background,
              tabBar: MenuIOS(
                currentIndex: value.selectPage,
                onTap: (index) => context.read<PagesProvider>().togglePage(index),
                backgroundColor: context.color.backgroundCard,
                activeColor: context.color.textSecondary2,
                inactiveColor: context.color.textSecondary,
              ),
              tabBuilder: (context, index) {
                return CupertinoTabView(
                  builder:
                      (context) => Column(
                        children: [
                          SizedBox(height: widget.toolbarHeight),
                          Expanded(
                            child: IndexedStack(index: value.selectPage, children: pagesIOS),
                          ),
                        ],
                      ),
                );
              },
            );
          } else {
            return CupertinoPageScaffold(
              backgroundColor: context.color.background,
              child: Column(
                children: [
                  SizedBox(height: widget.toolbarHeight),
                  Expanded(child: IndexedStack(index: value.selectPage, children: pagesIOS)),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildMaterialScaffold(BuildContext context) {
    final List<Widget> pageAndroid = [PageHomeAndroid(widget: widget), const SettingPage()];
    return ChangeNotifierProvider<PagesProvider>(
      create: (BuildContext context) => PagesProvider(),
      child: Consumer<PagesProvider>(
        builder: (BuildContext context, PagesProvider value, Widget? child) {
          return Scaffold(
            backgroundColor: context.color.background,
            body: Column(
              children: [
                SizedBox(height: widget.toolbarHeight),
                Expanded(child: IndexedStack(index: value.selectPage, children: pageAndroid)),
              ],
            ),
            bottomNavigationBar: widget.showMenu ? const MenuAndroid() : null,
          );
        },
      ),
    );
  }
}
