import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

/// Widget compartido para iconos de navegación que puede ser reutilizado
/// en diferentes plataformas (Android e iOS)
class SharedIconMenu extends StatelessWidget {
  const SharedIconMenu({super.key, required this.isSelected, required this.path});

  static const double _iconSize = 24.0;

  final bool isSelected;
  final String path;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: _iconSize,
      height: _iconSize,
      colorFilter: ColorFilter.mode(_getIconColor(context), BlendMode.srcIn),
    );
  }

  Color _getIconColor(BuildContext context) {
    return isSelected ? context.color.textSecondary2 : context.color.textSecondary;
  }
}
