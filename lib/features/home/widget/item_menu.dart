import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goncook/core/config/color/app_colors.dart';

class ItemMenu extends StatelessWidget {
  const ItemMenu({super.key, required this.title, this.onTap, this.style});

  final String title;
  final void Function()? onTap;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return isIOS
        ? CupertinoActionSheetAction(
            onPressed: onTap ?? () {},
            isDestructiveAction: true,
            isDefaultAction: false,
            child: Text(title, style: const TextStyle(fontSize: 16, color: AppColors.slate700)),
          )
        : ListTile(
            title: Text(
              title,
              style: style ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onTap: onTap,
          );
  }
}
