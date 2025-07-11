import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class LogoWidget extends StatefulWidget {
  const LogoWidget({super.key});

  @override
  State<LogoWidget> createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _gradientController;
  late AnimationController _pulseController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _gradientAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Controlador de rotación sutil
    _rotationController = AnimationController(duration: const Duration(seconds: 10), vsync: this);

    // Controlador de escala con rebote
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Controlador de gradiente animado
    _gradientController = AnimationController(duration: const Duration(seconds: 3), vsync: this);

    // Controlador de pulso
    _pulseController = AnimationController(duration: const Duration(seconds: 2), vsync: this);

    // Configurar animaciones
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(parent: _rotationController, curve: Curves.linear));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut));

    _gradientAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    // Iniciar animaciones
    _startAnimations();
  }

  void _startAnimations() {
    // Rotación continua muy lenta
    _rotationController.repeat();

    // Entrada con rebote
    _scaleController.forward();

    // Gradiente cíclico
    _gradientController.repeat(reverse: true);

    // Pulso cíclico
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _gradientController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _rotationAnimation,
        _scaleAnimation,
        _gradientAnimation,
        _pulseAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value * _pulseAnimation.value,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                center: Alignment.center,
                startAngle: _gradientAnimation.value * 2 * math.pi,
                endAngle: (_gradientAnimation.value * 2 * math.pi) + (2 * math.pi),
                colors: [
                  context.color.buttonPrimary, // Verde oscuro
                  context.color.error, // Verde medio
                  context.color.buttonPrimary, // Verde claro
                  context.color.error, // Amarillo (ají amarillo)
                  context.color.buttonPrimary, // Naranja (rocoto)
                  context.color.error, // Verde oscuro (completa el ciclo)
                  context.color.buttonPrimary,
                  context.color.error,
                ],
                stops: const [0.0, 0.2, 0.3, 0.4, 0.5, 0.6, 0.8, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: context.color.buttonPrimary.withAlpha(100),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: context.color.error.withAlpha(50),
                  blurRadius: 5,
                  spreadRadius: 1,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.color.background,
                boxShadow: [
                  BoxShadow(
                    color: context.color.buttonPrimary.withAlpha(50),
                    blurRadius: 5,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/img/logoOutName.png',
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ShimmerPainter extends CustomPainter {
  final double animationValue;

  ShimmerPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment(-1.0 + (animationValue * 2), -1.0),
            end: Alignment(1.0 + (animationValue * 2), 1.0),
            colors: [Colors.transparent, Colors.white.withOpacity(0.2), Colors.transparent],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(ShimmerPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
