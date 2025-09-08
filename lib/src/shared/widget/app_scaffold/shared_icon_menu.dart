import 'package:flutter/material.dart';
import 'package:recetasperuanas/src/shared/controller/base_controller.dart';
import 'package:recetasperuanas/src/shared/widget/app_svg.dart';

class SharedIconMenu extends StatelessWidget {
  const SharedIconMenu({super.key, required this.isSelected, required this.path});

  static const double _iconSize = 24.0;

  final bool isSelected;
  final String path;

  @override
  Widget build(BuildContext context) {
    return AppSvgIcon(assetPath: path, size: _iconSize, color: _getIconColor(context));
  }

  Color _getIconColor(BuildContext context) {
    return isSelected ? context.color.textSecondary2 : context.color.textSecondary;
  }
}
