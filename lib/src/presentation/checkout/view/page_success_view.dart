import 'package:confetti/confetti.dart' show ConfettiController;
import 'package:flutter/material.dart';
import 'package:recetasperuanas/src/presentation/checkout/widget/background.dart' show Background;
import 'package:recetasperuanas/src/presentation/checkout/widget/widget.dart' show Body;
import 'package:recetasperuanas/src/shared/widget/widget.dart' show AppConfetti;

class PageSuccess extends StatefulWidget {
  final String title;
  final Widget content;
  final String confirmLabel;
  final VoidCallback onConfirm;

  const PageSuccess({
    super.key,
    required this.title,
    required this.content,
    required this.confirmLabel,
    required this.onConfirm,
  });

  @override
  State<PageSuccess> createState() => _PageSuccessState();
}

class _PageSuccessState extends State<PageSuccess> with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _backgroundController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _backgroundController, curve: Curves.easeOutCubic));

    // Inicializar confeti
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));

    // Iniciar animaciones
    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _backgroundController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _confettiController.play();

    await Future.delayed(const Duration(milliseconds: 600));
    _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    _scaleController.forward();

    await Future.delayed(const Duration(milliseconds: 1000));
    _slideController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          Background(backgroundAnimation: _backgroundAnimation),
          AppConfetti(confettiController: _confettiController),
          Body(
            fadeAnimation: _fadeAnimation,
            scaleAnimation: _scaleAnimation,
            slideAnimation: _slideAnimation,
            widget: widget,
          ),
        ],
      ),
    );
  }
}
