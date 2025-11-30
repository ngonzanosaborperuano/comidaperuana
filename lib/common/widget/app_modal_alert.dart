import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/features/core/config/config.dart';
import 'package:goncook/common/controller/base_controller.dart';
import 'package:goncook/common/widget/app_button_icon.dart';
import 'package:goncook/common/widget/spacing/spacing.dart';

class AppModalAlert extends StatelessWidget {
  const AppModalAlert({
    required this.text,
    this.maxHeight,
    this.title,
    super.key,
    this.icon,
    this.labelButton,
    this.onPressed,
  });

  final String? title;
  final String text;
  final double? maxHeight;
  final IconData? icon;
  final String? labelButton;
  final void Function()? onPressed;

  Future<void> show(BuildContext context) async {
    return showAdaptiveDialog(context: context, builder: build);
  }

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? _buildCupertinoDialog(context, context.color.error, context.color.errorBackground)
        : _buildMaterialDialog(context, context.color.errorBackground, context.color.error);
  }

  Widget _buildMaterialDialog(BuildContext context, Color dialogColor, Color textColor) {
    return Dialog(
      surfaceTintColor: dialogColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: textColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xmd),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (title != null && icon != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 24, color: context.color.error),
                  AppHorizontalSpace.sm,
                  Expanded(
                    child: Text(
                      title!,
                      textAlign: TextAlign.left,
                      style: AppStyles.h2TextBlack.copyWith(color: context.color.error),
                    ),
                  ),
                ],
              ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                text,
                style: AppStyles.bodyTextNoOverflow.copyWith(color: context.color.text),
              ),
            ),
            AppButton(
              text: labelButton ?? context.loc.accept,
              onPressed: onPressed ?? () => context.pop(),
              showIcon: false,
              isCancel: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCupertinoDialog(BuildContext context, Color dialogColor, Color textColor) {
    return CupertinoAlertDialog(
      title: title != null
          ? Row(
              children: [
                Icon(icon, color: AppColors.red700, size: 24),
                AppHorizontalSpace.sm,
                Text(title!, style: const TextStyle(color: AppColors.red700)),
              ],
            )
          : null,
      content: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          text,
          style: AppStyles.bodyTextNoOverflow.copyWith(color: context.color.text),
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: onPressed ?? () => context.pop(),
          child: Text(
            labelButton ?? context.loc.accept,
            style: const TextStyle(color: AppColors.red700),
          ),
        ),
      ],
    );
  }
}
