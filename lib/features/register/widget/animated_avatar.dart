import 'package:flutter/material.dart';
import 'package:goncook/common/controller/base_controller.dart';

class AnimatedAvatar extends StatefulWidget {
  const AnimatedAvatar({super.key, this.radius = 30, this.iconSize = 30, this.onTap});

  final double radius;
  final double iconSize;
  final VoidCallback? onTap;

  @override
  State<AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<AnimatedAvatar> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;

  late Animation<double> _bounceAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 500), // Reducido de 600ms
      vsync: this,
    );

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000), // Aumentado de 2000ms para rotación más sutil
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000), // Aumentado de 1500ms para pulso más suave
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    // Iniciar animaciones
    _startAnimations();
  }

  void _startAnimations() async {
    // Animación de rebote inicial
    await Future.delayed(const Duration(milliseconds: 500));
    _bounceController.forward();

    // Animación de rotación continua
    await Future.delayed(const Duration(milliseconds: 800));
    _rotateController.repeat();

    // Animación de pulso
    await Future.delayed(const Duration(milliseconds: 1000));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTap() {
    // Efecto de rebote al tocar
    _bounceController.reset();
    _bounceController.forward();

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_bounceAnimation, _rotateAnimation, _pulseAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value * _pulseAnimation.value,
            child: Transform.rotate(
              angle: _rotateAnimation.value * 0.1, // Rotación sutil
              child: child,
            ),
          );
        },
        // Construir el widget estático una sola vez
        child: CircleAvatar(
          radius: widget.radius,
          backgroundColor: context.color.textSecondary2Invert,
          child: Icon(Icons.person_add, size: widget.iconSize, color: context.color.background),
        ),
      ),
    );
  }
}
