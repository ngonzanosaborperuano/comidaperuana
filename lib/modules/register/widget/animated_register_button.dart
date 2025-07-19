import 'package:flutter/material.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

class AnimatedRegisterButton extends StatefulWidget {
  const AnimatedRegisterButton({super.key, required this.onPressed, required this.isLoading});

  final Future<void> Function() onPressed;
  final bool isLoading;

  @override
  State<AnimatedRegisterButton> createState() => _AnimatedRegisterButtonState();
}

class _AnimatedRegisterButtonState extends State<AnimatedRegisterButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handlePress() async {
    _controller.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _controller.reverse();

    if (!widget.isLoading) {
      await widget.onPressed();
    }
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
      // Construir el botón una sola vez
      child: AppButton(
        text: widget.isLoading ? '${context.loc.register}...' : context.loc.register,
        onPressed: widget.isLoading ? null : _handlePress,
        showIcon: false,
      ),
    );
  }
}
