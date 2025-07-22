import 'package:flutter/material.dart';
import 'package:recetasperuanas/modules/login/widget/logo_widget.dart' show LogoWidget;
import 'package:recetasperuanas/modules/login/widget/widget.dart' show AnimatedLoginForm;
import 'package:recetasperuanas/shared/widget/animated_widgets.dart'
    show AnimatedScaleWidget, AnimatedLogoWidget;

class LogoLogin extends StatelessWidget {
  const LogoLogin({super.key, required this.widget});

  final AnimatedLoginForm widget;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedScaleWidget(
        animation: widget.animation,
        child: const AnimatedLogoWidget(child: Hero(tag: 'logo', child: LogoWidget())),
      ),
    );
  }
}
