import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/config/color/app_colors.dart';
import 'package:recetasperuanas/core/config/style/app_styles.dart';

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
          child: Text(title, style: AppStyles.bodyText.copyWith(color: AppColors.slate700)),
        )
        : ListTile(title: Text(title, style: style ?? AppStyles.bodyTextBoldPrimary), onTap: onTap);
  }
}
