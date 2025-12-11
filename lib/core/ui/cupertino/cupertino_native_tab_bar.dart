import 'package:cupertino_native/cupertino_native.dart';
import 'package:flutter/cupertino.dart';

/// Tab bar nativa (UITabBar) para iOS.
class CupertinoNativeTabBar extends StatelessWidget {
  /// Crea una tab bar con items e índice actual.
  const CupertinoNativeTabBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  /// Items del tab bar.
  final List<CNTabBarItem> items;

  /// Índice seleccionado.
  final int currentIndex;

  /// Callback al tocar.
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return CNTabBar(items: items, currentIndex: currentIndex, onTap: onTap);
  }
}

/// Alias de item nativo.
typedef CupertinoNativeTabBarItem = CNTabBarItem;
