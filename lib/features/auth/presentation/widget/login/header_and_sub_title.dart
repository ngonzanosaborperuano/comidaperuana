import 'package:flutter/material.dart';
import 'package:goncook/common/widget/spacing/spacing.dart' show AppSpacing;
import 'package:goncook/common/widget/text_widget.dart' show AppText;
import 'package:goncook/core/extension/extension.dart';

class HeaderAndSubTitle extends StatelessWidget {
  const HeaderAndSubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.md,
      children: [
        RepaintBoundary(
          child: AppText(
            text: context.loc.login,
            fontSize: AppSpacing.xxmd,
            fontWeight: FontWeight.bold,
            color: context.color.text,
          ),
        ),
        RepaintBoundary(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppText(
              text: context.loc.descriptionLogin,
              fontSize: AppSpacing.md,
              fontWeight: FontWeight.w400,
              color: context.color.text,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
