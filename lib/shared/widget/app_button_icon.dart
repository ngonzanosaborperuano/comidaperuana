import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/spacing/spacing.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    required this.text,
    this.onPressed,
    super.key,
    this.iconWidget,
    this.enabledButton = true,
    this.showIcon = true,
    this.rounded = true,
    this.isCancel = false,
    this.isAlternative = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool enabledButton;
  final bool showIcon;
  final bool rounded;
  final Widget? iconWidget;
  final bool isCancel;
  final bool isAlternative;

  @override
  Widget build(BuildContext context) {
    Color colorPrimary;
    Color colorSecondary;
    if (isAlternative) {
      colorPrimary = AppColorScheme.of(context).secondary;
      colorSecondary = AppColorScheme.of(context).primary;
    } else {
      colorPrimary =
          isCancel ? AppColorScheme.of(context).secondary : AppColorScheme.of(context).primary;

      colorSecondary =
          isCancel ? AppColorScheme.of(context).primary : AppColorScheme.of(context).secondary;
    }

    return Theme.of(context).platform == TargetPlatform.iOS
        ? _buildCupertinoButton(context, colorPrimary, colorSecondary)
        : _buildMaterialButton(context, colorPrimary, colorSecondary);
  }

  Widget _buildMaterialButton(BuildContext context, Color colorPrimary, Color colorSecundary) {
    return ElevatedButton(
      onPressed: enabledButton ? onPressed : null,
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(15)),
        backgroundColor: WidgetStateProperty.all(colorSecundary),
        foregroundColor: WidgetStateProperty.all(colorSecundary),
        overlayColor: WidgetStateProperty.all(colorSecundary),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: rounded ? BorderRadius.circular(10) : BorderRadius.zero,
            side: BorderSide(color: context.color.secondary),
          ),
        ),
        elevation: WidgetStateProperty.all(0),
      ),
      child: _buildButtonContent(colorPrimary, context),
    );
  }

  Widget _buildCupertinoButton(BuildContext context, Color colorPrimary, Color colorSecundary) {
    return CupertinoButton(
      onPressed: enabledButton ? onPressed : null,
      color: colorSecundary,
      borderRadius: rounded ? BorderRadius.circular(10) : BorderRadius.zero,
      child: _buildButtonContent(colorPrimary, context),
    );
  }

  Widget _buildButtonContent(Color colorSecundary, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!showIcon) ...[
          AppHorizontalSpace.sm,
        ] else ...[
          iconWidget ?? const SizedBox(),
          AppHorizontalSpace.sm,
        ],
        Text(
          text,
          style: TextStyle(color: colorSecundary, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
