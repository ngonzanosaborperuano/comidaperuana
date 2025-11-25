import 'package:flutter/material.dart';
import 'package:goncook/src/presentation/login/widget/logo_widget.dart' show LogoWidget;
import 'package:goncook/src/shared/widget/animated_widgets.dart'
    show AnimatedScaleWidget, AnimatedLogoWidget;

class LogoLogin extends StatelessWidget {
  const LogoLogin({super.key, required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedScaleWidget(
        animation: animation,
        child: const AnimatedLogoWidget(
          child: Hero(tag: 'logo', child: LogoWidget()),
        ),
      ),
    );
  }
}
