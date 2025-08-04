import 'package:flutter/material.dart';
import 'package:recetasperuanas/modules/login/widget/widget.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/animated_widgets.dart'
    show AnimatedEntryWidget;
import 'package:recetasperuanas/shared/widget/spacing/spacing.dart'
    show AppSpacing;
import 'package:recetasperuanas/shared/widget/text_widget.dart' show AppText;

class HeaderAndSubTitle extends StatelessWidget {
  const HeaderAndSubTitle({super.key, required this.widget});

  final AnimatedLoginForm widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.md,
      children: [
        RepaintBoundary(
          child: AnimatedEntryWidget(
            animation: widget.animation,
            slideOffset: const Offset(0, 0.2),
            child: AppText(
              text: context.loc.login,
              fontSize: AppSpacing.xxmd,
              fontWeight: FontWeight.bold,
              color: context.color.text,
            ),
          ),
        ),
        RepaintBoundary(
          child: FadeTransition(
            opacity: widget.animation,
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
        ),
      ],
    );
  }
}
