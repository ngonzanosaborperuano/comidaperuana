import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/core/constants/routes.dart' show Routes;
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({
    required this.body,
    this.onBackPressed,
    this.title,
    this.customDrawer,
    super.key,
    this.toolbarHeight = 70,
    this.onPressed,
    this.showMenu = false,
  });

  final Widget? title;
  final Widget body;
  final VoidCallback? onBackPressed;
  final double toolbarHeight;
  final Widget? customDrawer;
  final void Function()? onPressed;
  final bool showMenu;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    int selectedIndex = 0;

    return SafeArea(
      bottom: false,
      child:
          isIOS
              ? _buildCupertinoScaffold(context, selectedIndex)
              : _buildMaterialScaffold(context, selectedIndex),
    );
  }

  Widget _buildCupertinoScaffold(BuildContext context, int selectedIndex) {
    return CupertinoPageScaffold(
      backgroundColor: context.color.textSecundary,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CustomScrollView(
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
                          child: Icon(CupertinoIcons.back, size: 30, color: context.color.primary),
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
          ),
          if (widget.showMenu) ...[
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
                    BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.book, color: Colors.transparent),
                    ),
                    BottomNavigationBarItem(icon: Icon(CupertinoIcons.heart_solid)),
                    BottomNavigationBarItem(icon: Icon(CupertinoIcons.settings)),
                  ],
                  onTap: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                    switch (index) {
                      case 0:
                        context.push('/trabajador/home');
                        break;
                      case 1:
                        context.push('/trabajador/ruta');
                        break;
                      case 2:
                        // context.push('/trabajador/pagos');
                        break;
                      case 3:
                        context.push('/trabajador/pagos');
                        break;
                      case 4:
                        context.go(Routes.setting.description);
                        break;
                    }
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
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.all(8),
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
        ],
      ),
    );
  }

  Widget _buildMaterialScaffold(BuildContext context, int selectedIndex) {
    return Scaffold(
      backgroundColor: context.color.textSecundary,
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        elevation: 0,
        leadingWidth: 36,
        title: widget.title,
        toolbarHeight: widget.toolbarHeight,
        leading:
            widget.onBackPressed != null
                ? IconButton(
                  onPressed: widget.onBackPressed,
                  icon: Icon(Icons.arrow_back, color: context.color.menuIsNotActive),
                )
                : null,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          widget.body,
          if (widget.showMenu) ...[
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
                  selectedFontSize: 0,
                  unselectedFontSize: 0,
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
                    setState(() {
                      selectedIndex = index;
                    });
                    switch (index) {
                      case 0:
                        context.push('/trabajador/home');
                        break;
                      case 1:
                        context.push('/trabajador/ruta');
                        break;
                      case 2:
                        // context.push('/trabajador/pagos');
                        break;
                      case 3:
                        context.push('/trabajador/pagos');
                        break;
                      case 4:
                        context.go(Routes.setting.description);
                        break;
                    }
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
                      offset: Offset(0, 10),
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
        ],
      ),
    );
  }
}
