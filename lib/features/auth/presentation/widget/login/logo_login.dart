import 'package:flutter/material.dart';
import 'package:goncook/common/widget/animated_widgets.dart'
    show AnimatedScaleWidget, AnimatedLogoWidget;
import 'package:goncook/features/auth/presentation/widget/logo_widget.dart' show LogoWidget;

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
