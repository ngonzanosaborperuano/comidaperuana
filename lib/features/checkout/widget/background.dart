import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key, required Animation<double> backgroundAnimation})
    : _backgroundAnimation = backgroundAnimation;

  final Animation<double> _backgroundAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(
                  const Color(0xFF1A237E),
                  const Color(0xFF0D47A1),
                  _backgroundAnimation.value,
                )!,
                Color.lerp(
                  const Color(0xFF1565C0),
                  const Color(0xFF0277BD),
                  _backgroundAnimation.value,
                )!,
                Color.lerp(
                  const Color(0xFF00695C),
                  const Color(0xFF004D40),
                  _backgroundAnimation.value,
                )!,
              ],
            ),
          ),
        );
      },
    );
  }
}
