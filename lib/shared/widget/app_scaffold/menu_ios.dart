import 'package:flutter/cupertino.dart';

class MenuIOS extends CupertinoTabBar {
  const MenuIOS({
    super.key,
    required super.currentIndex,
    required ValueChanged<int> super.onTap,
    required Color super.backgroundColor,
    required Color super.activeColor,
    required super.inactiveColor,
  }) : super(
         items: const [
           BottomNavigationBarItem(
             icon: Padding(padding: EdgeInsets.all(8.0), child: Icon(CupertinoIcons.home)),
             label: 'Inicio',
           ),
           BottomNavigationBarItem(
             icon: Padding(padding: EdgeInsets.all(8.0), child: Icon(CupertinoIcons.chart_bar)),
             label: 'Análisis',
           ),
           BottomNavigationBarItem(
             icon: Padding(padding: EdgeInsets.all(8.0), child: Icon(CupertinoIcons.calendar)),
             label: 'Planifica',
           ),
           BottomNavigationBarItem(
             icon: Padding(padding: EdgeInsets.all(8.0), child: Icon(CupertinoIcons.person)),
             label: 'Perfil',
           ),
         ],
       );
}
