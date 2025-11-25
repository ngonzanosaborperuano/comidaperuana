import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/src/presentation/core/bloc/pages_bloc.dart';
import 'package:goncook/src/presentation/setting/view/setting_page.dart';
import 'package:goncook/src/shared/controller/base_controller.dart';
import 'package:goncook/src/shared/widget/app_scaffold/menu_android.dart';
import 'package:goncook/src/shared/widget/app_scaffold/menu_ios.dart';
import 'package:goncook/src/shared/widget/app_scaffold/page_home_android.dart';
import 'package:goncook/src/shared/widget/app_scaffold/page_home_ios.dart';

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

    return BlocProvider<PagesBloc>(
      create: (_) => PagesBloc(),
      child: isIOS ? _buildCupertinoScaffold(context) : _buildMaterialScaffold(context),
    );
  }

  Widget _buildCupertinoScaffold(BuildContext context) {
    final List<Widget> pagesIOS = [PageHomeIOS(widget: widget), const SettingPage()];
    return BlocBuilder<PagesBloc, PagesState>(
      builder: (context, state) {
        final selectedPage = state is PagesLoaded ? state.selectedPage : 0;

        if (widget.showMenu) {
          return MenuIOS(pagesIOS: pagesIOS, toolbarHeight: widget.toolbarHeight);
        } else {
          return CupertinoPageScaffold(
            backgroundColor: context.color.background,
            child: Column(
              children: [
                SizedBox(height: widget.toolbarHeight),
                Expanded(
                  child: IndexedStack(index: selectedPage, children: pagesIOS),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildMaterialScaffold(BuildContext context) {
    final List<Widget> pageAndroid = [PageHomeAndroid(widget: widget), const SettingPage()];
    return BlocBuilder<PagesBloc, PagesState>(
      builder: (context, state) {
        final selectedPage = state is PagesLoaded ? state.selectedPage : 0;

        return Scaffold(
          backgroundColor: context.color.background,
          body: Column(
            children: [
              SizedBox(height: widget.toolbarHeight),
              Expanded(
                child: IndexedStack(index: selectedPage, children: pageAndroid),
              ),
            ],
          ),
          bottomNavigationBar: widget.showMenu ? const MenuAndroid() : null,
        );
      },
    );
  }
}
