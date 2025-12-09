import 'package:flutter/material.dart';
import 'package:goncook/common/widget/app_svg.dart';
import 'package:goncook/core/extension/extension.dart';

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
