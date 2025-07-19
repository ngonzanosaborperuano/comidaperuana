import 'package:flutter/material.dart';

/// Curva personalizada que garantiza valores en el rango [0, 1]
class SafeCurve extends Curve {
  final Curve curve;

  const SafeCurve(this.curve);

  @override
  double transform(double t) {
    // Asegurar que el input esté en el rango [0, 1]
    final clampedT = t.clamp(0.0, 1.0);
    // Aplicar la curva original
    final result = curve.transform(clampedT);
    // Asegurar que el resultado esté en el rango [0, 1]
    return result.clamp(0.0, 1.0);
  }
}

/// Curva elástica segura que no excede el rango [0, 1]
class SafeElasticOutCurve extends Curve {
  @override
  double transform(double t) {
    final clampedT = t.clamp(0.0, 1.0);
    if (clampedT == 0.0) return 0.0;
    if (clampedT == 1.0) return 1.0;

    // Implementación simplificada que simula elastic out
    // Usando una combinación de curvas seguras
    final easeOut = Curves.easeOut.transform(clampedT);
    final bounce = Curves.bounceOut.transform(clampedT);

    // Combinar las curvas de manera segura
    final result = (easeOut + bounce) / 2;
    return result.clamp(0.0, 1.0);
  }
}

/// Widget de animación de entrada con fade y slide
class AnimatedEntryWidget extends StatelessWidget {
  const AnimatedEntryWidget({
    super.key,
    required this.animation,
    required this.child,
    this.slideOffset = const Offset(0, 0.3),
    this.curve = Curves.easeOutCubic,
  });

  final Animation<double> animation;
  final Widget child;
  final Offset slideOffset;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: slideOffset,
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: SafeCurve(curve))),
        child: child,
      ),
    );
  }
}

/// Widget de animación de escala con rebote
class AnimatedScaleWidget extends StatelessWidget {
  const AnimatedScaleWidget({
    super.key,
    required this.animation,
    required this.child,
    this.curve = Curves.easeOutBack,
  });

  final Animation<double> animation;
  final Widget child;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: animation, curve: SafeCurve(curve))),
      child: child,
    );
  }
}

/// Widget de animación de rotación
class AnimatedRotationWidget extends StatelessWidget {
  const AnimatedRotationWidget({
    super.key,
    required this.animation,
    required this.child,
    this.beginAngle = 0.0,
    this.endAngle = 0.1,
    this.curve = Curves.easeInOut,
  });

  final Animation<double> animation;
  final Widget child;
  final double beginAngle;
  final double endAngle;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween<double>(
        begin: beginAngle,
        end: endAngle,
      ).animate(CurvedAnimation(parent: animation, curve: SafeCurve(curve))),
      child: child,
    );
  }
}

/// Widget de animación de pulso
class AnimatedPulseWidget extends StatelessWidget {
  const AnimatedPulseWidget({
    super.key,
    required this.animation,
    required this.child,
    this.minScale = 0.95,
    this.maxScale = 1.05,
    this.curve = Curves.easeInOut,
  });

  final Animation<double> animation;
  final Widget child;
  final double minScale;
  final double maxScale;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Usar la curva segura
        final safeCurve = SafeCurve(curve);
        final clampedValue = safeCurve.transform(animation.value);
        final scale = minScale + (maxScale - minScale) * clampedValue;
        return Transform.scale(scale: scale, child: child);
      },
      child: child,
    );
  }
}

/// Widget de animación de botón con efecto de presión
class AnimatedPressButton extends StatefulWidget {
  const AnimatedPressButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.duration = const Duration(milliseconds: 150),
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final Duration duration;

  @override
  State<AnimatedPressButton> createState() => _AnimatedPressButtonState();
}

class _AnimatedPressButtonState extends State<AnimatedPressButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: const SafeCurve(Curves.easeInOut)));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: const SafeCurve(Curves.easeInOut)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handlePress() async {
    if (widget.isLoading) return;

    _controller.forward();
    await Future.delayed(Duration(milliseconds: widget.duration.inMilliseconds ~/ 2));
    _controller.reverse();

    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(opacity: _opacityAnimation.value, child: child),
        );
      },
      child: GestureDetector(onTap: _handlePress, child: widget.child),
    );
  }
}

/// Widget de animación de logo con efectos combinados
class AnimatedLogoWidget extends StatefulWidget {
  const AnimatedLogoWidget({
    super.key,
    required this.child,
    this.onTap,
    this.enablePulse = true,
    this.enableRotation = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool enablePulse;
  final bool enableRotation;

  @override
  State<AnimatedLogoWidget> createState() => _AnimatedLogoWidgetState();
}

class _AnimatedLogoWidgetState extends State<AnimatedLogoWidget> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  late Animation<double> _bounceAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: const SafeCurve(Curves.easeOutBack)),
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _pulseController, curve: const SafeCurve(Curves.easeInOut)));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _rotateController, curve: const SafeCurve(Curves.easeInOut)));

    _startAnimations();
  }

  void _startAnimations() async {
    // Animación de rebote inicial
    await Future.delayed(const Duration(milliseconds: 300));
    _bounceController.forward();

    // Animación de pulso continua
    if (widget.enablePulse) {
      await Future.delayed(const Duration(milliseconds: 500));
      _pulseController.repeat(reverse: true);
    }

    // Animación de rotación sutil
    if (widget.enableRotation) {
      await Future.delayed(const Duration(milliseconds: 800));
      _rotateController.repeat();
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
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
        animation: Listenable.merge([
          _bounceAnimation,
          if (widget.enablePulse) _pulseAnimation,
          if (widget.enableRotation) _rotateAnimation,
        ]),
        builder: (context, child) {
          // Usar curvas seguras para todos los valores
          final bounceValue = _bounceAnimation.value;
          final pulseValue = widget.enablePulse ? _pulseAnimation.value : 1.0;
          final rotateValue = widget.enableRotation ? _rotateAnimation.value : 0.0;

          double scale = bounceValue;
          if (widget.enablePulse) {
            scale *= pulseValue;
          }

          return Transform.scale(
            scale: scale,
            child: Transform.rotate(
              angle: widget.enableRotation ? rotateValue * 0.05 : 0.0,
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Mixin para manejar animaciones escalonadas
mixin StaggeredAnimationMixin<T extends StatefulWidget> on State<T>, TickerProvider {
  late AnimationController fadeController;
  late AnimationController slideController;
  late AnimationController scaleController;
  late AnimationController formController;

  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;
  late Animation<double> scaleAnimation;
  late Animation<double> formAnimation;

  void initializeAnimations({
    Duration fadeDuration = const Duration(milliseconds: 600),
    Duration slideDuration = const Duration(milliseconds: 500),
    Duration scaleDuration = const Duration(milliseconds: 600),
    Duration formDuration = const Duration(milliseconds: 800),
  }) {
    fadeController = AnimationController(duration: fadeDuration, vsync: this);
    slideController = AnimationController(duration: slideDuration, vsync: this);
    scaleController = AnimationController(duration: scaleDuration, vsync: this);
    formController = AnimationController(duration: formDuration, vsync: this);

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: fadeController, curve: const SafeCurve(Curves.easeInOut)));

    slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: slideController, curve: const SafeCurve(Curves.easeOutCubic)),
    );

    scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: scaleController, curve: const SafeCurve(Curves.easeOutBack)));

    formAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: formController, curve: const SafeCurve(Curves.easeInOut)));
  }

  Future<void> startStaggeredAnimations({
    Duration fadeDelay = const Duration(milliseconds: 50),
    Duration slideDelay = const Duration(milliseconds: 100),
    Duration scaleDelay = const Duration(milliseconds: 150),
    Duration formDelay = const Duration(milliseconds: 200),
  }) async {
    // Asegurar que los controladores estén en el estado correcto
    fadeController.reset();
    slideController.reset();
    scaleController.reset();
    formController.reset();

    await Future.delayed(fadeDelay);
    if (mounted) fadeController.forward();

    await Future.delayed(slideDelay);
    if (mounted) slideController.forward();

    await Future.delayed(scaleDelay);
    if (mounted) scaleController.forward();

    await Future.delayed(formDelay);
    if (mounted) formController.forward();
  }

  @override
  void dispose() {
    fadeController.dispose();
    slideController.dispose();
    scaleController.dispose();
    formController.dispose();
    super.dispose();
  }
}
