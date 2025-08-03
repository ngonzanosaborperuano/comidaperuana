import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    this.iconAtStart = false,
    this.isGoogle = false,
  });
  const AppButton.google({
    required this.text,
    this.onPressed,
    super.key,
    this.iconWidget,
    this.enabledButton = true,
    this.showIcon = true,
    this.rounded = true,
    this.isCancel = false,
    this.isAlternative = false,
    this.iconAtStart = false,
    this.isGoogle = true,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool enabledButton;
  final bool showIcon;
  final bool rounded;
  final Widget? iconWidget;
  final bool isCancel;
  final bool isAlternative;
  final bool iconAtStart;
  final bool isGoogle;

  @override
  Widget build(BuildContext context) {
    Color colorPrimary;
    Color colorSecondary;
    final color = context.color;
    if (isAlternative) {
      colorPrimary = color.buttonPrimary;
      colorSecondary = color.primary;
    } else if (isGoogle) {
      colorPrimary = color.text;
      colorSecondary = color.background;
    } else {
      colorPrimary = isCancel ? color.buttonPrimary : color.textNormal;
      colorSecondary = isCancel ? color.textOnPrimary : color.buttonPrimary;
    }

    return Theme.of(context).platform == TargetPlatform.iOS
        ? _buildCupertinoButton(context, colorPrimary, colorSecondary)
        : _buildMaterialButton(context, colorPrimary, colorSecondary);
  }

  Widget _buildMaterialButton(BuildContext context, Color colorPrimary, Color colorSecundary) {
    return ElevatedButton(
      onPressed: enabledButton ? onPressed : null,
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(AppSpacing.sl)),
        backgroundColor: WidgetStateProperty.all(colorSecundary),
        foregroundColor: WidgetStateProperty.all(colorSecundary),
        overlayColor: WidgetStateProperty.all(colorSecundary),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: rounded ? BorderRadius.circular(AppSpacing.xmd) : BorderRadius.zero,
            side: BorderSide(color: colorPrimary, width: 0.5),
          ),
        ),
        elevation: WidgetStateProperty.all(0),
      ),
      child: _buildButtonContent(colorPrimary, context),
    );
  }

  Widget _buildCupertinoButton(BuildContext context, Color colorPrimary, Color colorSecundary) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: rounded ? BorderRadius.circular(AppSpacing.xmd) : BorderRadius.zero,
        border: Border.all(color: colorPrimary, width: 0.5),
      ),
      child: CupertinoButton(
        sizeStyle: CupertinoButtonSize.medium,
        onPressed: enabledButton ? onPressed : null,
        color: colorSecundary,
        borderRadius: rounded ? BorderRadius.circular(AppSpacing.xmd) : BorderRadius.zero,
        child: _buildButtonContent(enabledButton ? colorPrimary : colorSecundary, context),
      ),
    );
  }

  Widget _buildButtonContent(Color colorSecundary, BuildContext context) {
    final textWidget = Text(
      text,
      style: TextStyle(color: colorSecundary, fontSize: AppSpacing.md, fontWeight: FontWeight.w700),
    );

    final iconTheme =
        showIcon && iconWidget != null
            ? IconTheme(data: IconThemeData(color: colorSecundary), child: iconWidget!)
            : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (iconAtStart) ...[
          if (iconTheme != null) ...[iconTheme, AppHorizontalSpace.sm],
          textWidget,
        ] else ...[
          textWidget,
          if (iconTheme != null) ...[AppHorizontalSpace.sm, iconTheme],
        ],
      ],
    );
  }
}
