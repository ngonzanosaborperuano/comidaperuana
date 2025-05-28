import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/modules/setting/view/setting_page.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({
    required this.body,
    this.onBackPressed,
    this.title,
    super.key,
    this.toolbarHeight = 70,
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

    return SafeArea(
      bottom: false,
      child:
          isIOS
              ? _buildCupertinoScaffold(context, selectedIndex)
              : _buildMaterialScaffold(context, selectedIndex),
    );
  }

  Widget _buildCupertinoScaffold(BuildContext context, int selectedIndex) {
    final List<Widget> pagesIOS = [_PageHomeIOS(widget: widget), const SettingPage()];
    return CupertinoPageScaffold(
      backgroundColor: context.color.textSecundary,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(child: IndexedStack(index: selectedIndex, children: pagesIOS)),
          if (widget.showMenu) ...[_menuIOS(context)],
        ],
      ),
    );
  }

  Stack _menuIOS(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: context.color.textSecundary,
              boxShadow: [
                BoxShadow(
                  color: context.color.menuActive,
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 5.5),
                ),
              ],
            ),
            child: CupertinoTabBar(
              backgroundColor: context.color.textSecundary,
              activeColor: context.color.menuIsNotActive,
              inactiveColor: context.color.menuActive,
              currentIndex: selectedIndex,
              height: kToolbarHeight,
              items: const [
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.home)),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.graph_square_fill)),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.book, color: Colors.transparent)),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.heart_solid)),
                BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings)),
              ],
              onTap: (index) {
                selectedIndex = index;
                setState(() {});
                // switch (index) {
                //   case 0:
                //     // context.push('/trabajador/home');
                //     break;
                //   case 1:
                //     // context.push('/trabajador/ruta');
                //     break;
                //   case 2:
                //     // context.push('/trabajador/pagos');
                //     break;
                //   case 3:
                //     // context.push('/trabajador/pagos');
                //     break;
                //   case 4:
                //     // context.go(Routes.setting.description);
                //     break;
                // }
              },
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.04,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColorScheme.of(context).textSecundary,
              border: Border.all(color: context.color.menuIsNotActive, width: 4),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  spreadRadius: 0,
                  color: context.color.menuIsNotActive,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(8),
              height: widget.toolbarHeight,
              width: widget.toolbarHeight,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: widget.onPressed,
                child: Image.asset('assets/img/logoOutName.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialScaffold(BuildContext context, int selectedIndex) {
    final List<Widget> pageHomeAndroid = [_PageHomeAndroid(widget: widget), const SettingPage()];
    return Scaffold(
      backgroundColor: context.color.textSecundary,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(child: IndexedStack(index: selectedIndex, children: pageHomeAndroid)),
          if (widget.showMenu) ...[_menuAndroid(context)],
        ],
      ),
    );
  }

  Stack _menuAndroid(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: context.color.textSecundary,
              boxShadow: [
                BoxShadow(
                  color: context.color.menuActive,
                  blurRadius: 5,
                  spreadRadius: 2,
                  offset: const Offset(0, 5.5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: context.color.textSecundary,
              selectedItemColor: context.color.menuIsNotActive,
              unselectedItemColor: context.color.menuActive,
              currentIndex: selectedIndex,
              iconSize: 30,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: ''),
                BottomNavigationBarItem(
                  icon: Icon(Icons.book, color: Colors.transparent),
                  label: 'sss',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
              ],
              onTap: (index) {
                selectedIndex = index;
                setState(() {});
              },
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.03,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.color.textSecundary,
              border: Border.all(color: context.color.menuIsNotActive, width: 4),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  spreadRadius: 0,
                  color: context.color.menuIsNotActive,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/img/logoOutName.png',
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PageHomeIOS extends StatelessWidget {
  const _PageHomeIOS({required this.widget});

  final AppScaffold widget;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.onBackPressed != null)
                  CupertinoButton(
                    color: context.color.menuIsNotActive,
                    onPressed: widget.onBackPressed,
                    padding: EdgeInsets.zero,
                    child: Icon(
                      CupertinoIcons.back,
                      size: 30,
                      color: context.color.menuIsNotActive,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                const SizedBox(width: 5),
                Expanded(child: Center(child: widget.title)),
                const SizedBox(width: 5),
              ],
            ),
          ),
        ),
        SliverFillRemaining(child: widget.body),
      ],
    );
  }
}

class _PageHomeAndroid extends StatelessWidget {
  const _PageHomeAndroid({required this.widget});
  final AppScaffold widget;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.onBackPressed != null || widget.title != null)
          SizedBox(
            height: widget.toolbarHeight,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 5),
              child: Row(
                children: [
                  if (widget.onBackPressed != null)
                    IconButton(
                      onPressed: widget.onBackPressed,
                      icon: Icon(Icons.arrow_back, color: context.color.menuIsNotActive),
                    ),
                  if (widget.title != null) Expanded(child: widget.title ?? const SizedBox()),
                ],
              ),
            ),
          ),
        Expanded(child: SizedBox(child: widget.body)),
      ],
    );
  }
}
