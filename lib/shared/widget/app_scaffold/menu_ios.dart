import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/provider/pages_provider.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class MenuIOS extends StatelessWidget {
  const MenuIOS({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PagesProvider>(
      builder: (BuildContext context, PagesProvider value, Widget? child) {
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
                  currentIndex: value.selectPage,
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
                    context.read<PagesProvider>().togglePage(index);
                  },
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.04,
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
                child: Container(
                  padding: const EdgeInsets.all(8),
                  height: 60,
                  width: 60,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: Image.asset('assets/img/logoOutName.png', fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
