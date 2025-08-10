import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/config/color/app_colors.dart';
import 'package:recetasperuanas/core/config/style/app_styles.dart';
import 'package:recetasperuanas/shared/widget/spacing/spacing.dart' show AppSpacing;

class AppDecorations {
  static InputDecoration textFormFieldDecoration({String? hintText, IconData? suffixIcon}) {
    return InputDecoration(
      isDense: true,
      labelStyle: AppStyles.bodyText,
      alignLabelWithHint: false,
      hintText: hintText ?? '...',
      hintStyle: AppStyles.bodyHintText,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.background),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.background),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.red700),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.red700),
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: AppColors.backgroundCard,
      suffixIcon: Icon(suffixIcon, size: 24, color: AppColors.text),
      contentPadding: const EdgeInsets.all(AppSpacing.sm),
    );
  }
}
