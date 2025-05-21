import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/core/config/config.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/app_button_icon.dart';
import 'package:recetasperuanas/shared/widget/spacing/spacing.dart';

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
        ? _buildCupertinoDialog(
          context,
          AppColorScheme.of(context).errorPrimary,
          AppColorScheme.of(context).errorSecundary,
        )
        : _buildMaterialDialog(
          context,
          AppColorScheme.of(context).errorSecundary,
          AppColorScheme.of(context).errorPrimary,
        );
  }

  Widget _buildMaterialDialog(BuildContext context, Color dialogColor, Color textColor) {
    return Dialog(
      surfaceTintColor: dialogColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: textColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (title != null && icon != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 24, color: AppColorScheme.of(context).errorPrimary),
                  AppHorizontalSpace.sm,
                  Expanded(
                    child: Text(
                      title!,
                      textAlign: TextAlign.left,
                      style: AppStyles.h2TextBlack.copyWith(
                        color: AppColorScheme.of(context).errorPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                text,
                style: AppStyles.bodyTextNoOverflow.copyWith(
                  color: AppColorScheme.of(context).textPrimary,
                ),
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
      title:
          title != null
              ? Row(
                children: [
                  Icon(icon, color: AppColors.error, size: 24),
                  const SizedBox(width: 8),
                  Text(title!, style: TextStyle(color: AppColors.error)),
                ],
              )
              : null,
      content: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          text,
          style: AppStyles.bodyTextNoOverflow.copyWith(
            color: AppColorScheme.of(context).textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: onPressed ?? () => context.pop(),
          child: Text(labelButton ?? context.loc.accept, style: TextStyle(color: AppColors.error)),
        ),
      ],
    );
  }
}
