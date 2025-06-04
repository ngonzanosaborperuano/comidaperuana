import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/provider/pages_provider.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class MenuAndroid extends StatefulWidget {
  const MenuAndroid({super.key});

  @override
  State<MenuAndroid> createState() => _MenuAndroidState();
}

class _MenuAndroidState extends State<MenuAndroid> {
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
                  currentIndex: value.selectPage,
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
                    context.read<PagesProvider>().togglePage(index);
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
      },
    );
  }
}
