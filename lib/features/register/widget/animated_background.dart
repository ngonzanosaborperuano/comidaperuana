import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:goncook/core/extension/extension.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(duration: const Duration(seconds: 20), vsync: this)
      ..repeat();

    _pulseController = AnimationController(duration: const Duration(seconds: 3), vsync: this)
      ..repeat(reverse: true);

    _waveController = AnimationController(duration: const Duration(seconds: 8), vsync: this)
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo base con gradiente
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb), Color(0xFFf5576c)],
            ),
          ),
        ),

        // Círculos animados flotantes
        ...List.generate(6, (index) => _buildFloatingCircle(index)),

        // Ondas animadas
        _buildAnimatedWaves(),

        // Partículas brillantes
        _buildSparkles(),
      ],
    );
  }

  Widget _buildFloatingCircle(int index) {
    final random = math.Random(index);
    final size = 50.0 + random.nextDouble() * 100;
    final left = random.nextDouble() * 400;
    final top = random.nextDouble() * 800;
    final duration = Duration(seconds: 10 + random.nextInt(10));

    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Positioned(
          left: left,
          top: top,
          child: Transform.rotate(
            angle: _rotationController.value * 2 * math.pi,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    context.color.background.withAlpha(100),
                    context.color.background.withAlpha(50),
                    context.color.background.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedWaves() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return CustomPaint(
          painter: WavePainter(animation: _waveController, color: Colors.white.withOpacity(0.1)),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildSparkles() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return CustomPaint(
          painter: SparklePainter(animation: _pulseController),
          size: Size.infinite,
        );
      },
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }
}

class WavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  WavePainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final y = size.height * 0.8;
    const amplitude = 50.0;
    const frequency = 0.02;

    path.moveTo(0, y);
    for (double x = 0; x < size.width; x++) {
      final waveY = y + amplitude * math.sin(frequency * x + animation.value * 2 * math.pi);
      path.lineTo(x, waveY);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) => true;
}

class SparklePainter extends CustomPainter {
  final Animation<double> animation;

  SparklePainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(animation.value * 0.8)
      ..style = PaintingStyle.fill;

    final random = math.Random(42);
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final sparkleSize = 2.0 + random.nextDouble() * 3;

      canvas.drawCircle(Offset(x, y), sparkleSize, paint);
    }
  }

  @override
  bool shouldRepaint(SparklePainter oldDelegate) => true;
}
