import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ResponsiveConstrainedBox extends StatelessWidget {
  final Widget child;
  final double maxMobileWidth;
  final double maxTabletWidth;
  final double maxDesktopWidth;

  const ResponsiveConstrainedBox({
    super.key,
    required this.child,
    this.maxMobileWidth = double.infinity,
    this.maxTabletWidth = 600,
    this.maxDesktopWidth = 800,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile:
          (_) => Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxMobileWidth),
              child: child,
            ),
          ),
      tablet:
          (_) => Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxTabletWidth),
              child: child,
            ),
          ),
      desktop:
          (_) => Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxDesktopWidth),
              child: child,
            ),
          ),
    );
  }
}
