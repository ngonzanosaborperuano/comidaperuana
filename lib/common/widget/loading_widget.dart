import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goncook/core/extension/extension.dart';

class LoadingClassicWidget extends StatelessWidget {
  const LoadingClassicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return const CupertinoActivityIndicator(radius: 20.0);
    } else {
      return const CircularProgressIndicator(strokeWidth: 3.0);
    }
  }
}

/// Widget de animación de carga circular con efecto de brillo
class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.linear));

    _animationController
      ..forward()
      ..addListener(_animationRotation);
  }

  void _animationRotation() {
    if (_animationController.status == AnimationStatus.completed) {
      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 40.0; // Radio del círculo
    const double baseItemSize = 8.0; // Tamaño base de cada item
    const double maxItemSize = 12.0; // Tamaño máximo (para el efecto de brillo)
    const int itemCount = 20; // Número de items

    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (BuildContext context, Widget? child) {
        return Center(
          child: SizedBox(
            width: (radius + maxItemSize) * 2,
            height: (radius + maxItemSize) * 2,
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(itemCount, (index) {
                // Calcular el ángulo para cada item (distribuidos equitativamente)
                final double angle = (2 * pi * index) / itemCount;

                // Calcular la posición angular actual de la animación
                final double animationAngle = _rotationAnimation.value * 2 * pi;

                // Calcular la diferencia angular entre el punto y la animación
                // Normalizar a un rango de -pi a pi
                double angleDiff = angle - animationAngle;
                while (angleDiff > pi) {
                  angleDiff -= 2 * pi;
                }
                while (angleDiff < -pi) {
                  angleDiff += 2 * pi;
                }
                angleDiff = angleDiff.abs();

                // Normalizar la diferencia angular (0 a 1, donde 0 es el punto más brillante)
                // Usamos un rango de ~180 grados (pi) para el efecto de arco más visible
                final double normalizedDiff = (angleDiff / pi).clamp(0.0, 1.0);

                // Calcular opacidad con curva suave (ease-out exponencial)
                // Usar una curva exponencial para un efecto más pronunciado
                final double opacityCurve = pow(1.0 - normalizedDiff, 2.0).toDouble();
                final double opacity = (0.15 + opacityCurve * 0.85).clamp(0.15, 1.0);

                // Calcular tamaño con la misma curva
                final double sizeCurve = pow(1.0 - normalizedDiff, 1.5).toDouble();
                final double itemSize = baseItemSize + (maxItemSize - baseItemSize) * sizeCurve;

                // Calcular posición x e y usando trigonometría
                final double x = radius * cos(angle);
                final double y = radius * sin(angle);

                return Positioned(
                  left: (radius + maxItemSize) + x - (itemSize / 2),
                  top: (radius + maxItemSize) + y - (itemSize / 2),
                  child: Container(
                    width: itemSize,
                    height: itemSize,
                    decoration: BoxDecoration(
                      color: context.color.buttonPrimary.withValues(alpha: opacity),
                      shape: BoxShape.circle,
                      boxShadow: opacity > 0.7
                          ? [
                              BoxShadow(
                                color: context.color.difficultyMediumText.withValues(
                                  alpha: opacity * 0.5,
                                ),
                                blurRadius: 4.0,
                                spreadRadius: 2.0,
                              ),
                              BoxShadow(
                                color: context.color.buttonPrimary.withValues(alpha: opacity),
                                blurRadius: 4.0,
                                spreadRadius: 1.0,
                              ),
                            ]
                          : null,
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
