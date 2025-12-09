import 'package:flutter/material.dart';
import 'package:goncook/common/widget/app_svg.dart';
import 'package:goncook/common/widget/widget.dart' show AppSpacing;
import 'package:goncook/core/config/color/app_color_scheme.dart';
import 'package:goncook/core/extension/extension.dart';

class AppLabel extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Widget? icon;

  const AppLabel({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.icon,
  });

  const AppLabel.facil({super.key, this.textAlign, this.maxLines, this.overflow})
    : text = 'difficultyEasy',
      style = null,
      icon = null;

  const AppLabel.media({super.key, this.textAlign, this.maxLines, this.overflow})
    : text = 'difficultyMedium',
      style = null,
      icon = null;

  const AppLabel.dificil({super.key, this.textAlign, this.maxLines, this.overflow})
    : text = 'difficultyHard',
      style = null,
      icon = null;

  // Constructor para etiquetas con icono
  const AppLabel.etiqueta({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.icon,
  });

  const AppLabel.custom({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.color;
    final localizedText = _getLocalizedText(context);
    final colors = _getColors(colorScheme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sl, vertical: AppSpacing.xs),
      decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            if (icon is AppSvgIcon)
              AppSvgIcon(assetPath: (icon as AppSvgIcon).assetPath, size: 16, color: colors.text)
            else
              IconTheme(
                data: IconThemeData(color: colors.text, size: 16),
                child: icon!,
              ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              localizedText,
              style: (style ?? const TextStyle()).copyWith(
                color: colors.text,
                fontSize: 14,
                fontWeight: text == 'difficultyHard' ? FontWeight.w600 : FontWeight.w500,
              ),
              textAlign: textAlign ?? TextAlign.center,
              maxLines: maxLines,
              overflow: overflow,
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedText(BuildContext context) {
    switch (text) {
      case 'difficultyEasy':
        return context.loc.difficultyEasy;
      case 'difficultyMedium':
        return context.loc.difficultyMedium;
      case 'difficultyHard':
        return context.loc.difficultyHard;
      default:
        return text;
    }
  }

  _LabelColors _getColors(AppColorScheme colorScheme) {
    switch (text) {
      case 'difficultyEasy':
        return _LabelColors(
          text: colorScheme.difficultyEasyText,
          background: colorScheme.difficultyEasyBackground,
        );
      case 'difficultyMedium':
        return _LabelColors(
          text: colorScheme.difficultyMediumText,
          background: colorScheme.difficultyMediumBackground,
        );
      case 'difficultyHard':
        return _LabelColors(
          text: colorScheme.difficultyHardText,
          background: colorScheme.difficultyHardBackground,
        );
      default:
        // Para etiquetas personalizadas, usar colores de etiqueta
        return _LabelColors(text: colorScheme.labelText, background: colorScheme.labelBackground);
    }
  }
}

class _LabelColors {
  final Color text;
  final Color background;

  const _LabelColors({required this.text, required this.background});
}

extension AppDifficultyTextExtension on BuildContext {
  AppLabel get facil => const AppLabel.facil();
  AppLabel get media => const AppLabel.media();
  AppLabel get dificil => const AppLabel.dificil();
  AppLabel etiqueta(String text, {Widget? icon}) => AppLabel.etiqueta(text: text, icon: icon);
}
