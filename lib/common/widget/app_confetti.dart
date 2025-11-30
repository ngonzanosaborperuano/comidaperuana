import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class AppConfetti extends StatelessWidget {
  const AppConfetti({super.key, required ConfettiController confettiController})
    : _confettiController = confettiController;

  final ConfettiController _confettiController;

  Path _createElegantParticle(Size size) {
    final random = math.Random();
    final shape = random.nextInt(4);

    switch (shape) {
      case 0: // Diamante
        return Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(size.width, size.height / 2)
          ..lineTo(size.width / 2, size.height)
          ..lineTo(0, size.height / 2)
          ..close();
      case 1: // Estrella de 5 puntas
        return _drawStar(size);
      case 2: // Círculo
        return Path()..addOval(
          Rect.fromCircle(
            center: Offset(size.width / 2, size.height / 2),
            radius: size.width / 2,
          ),
        );
      default: // Cuadrado con esquinas redondeadas
        return Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width, size.height),
            Radius.circular(size.width * 0.2),
          ),
        );
    }
  }

  Path _drawStar(Size size) {
    final path = Path();
    const n = 5;
    final r = size.width / 2;
    final R = r * 2.5;
    const angle = (2 * 3.1415926) / n;

    for (int i = 0; i < n; i++) {
      final x = r + R * math.cos(i * angle);
      final y = r + R * math.sin(i * angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      final x2 = r + r * math.cos(i * angle + angle / 2);
      final y2 = r + r * math.sin(i * angle + angle / 2);
      path.lineTo(x2, y2);
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        emissionFrequency: 0.06,
        numberOfParticles: 30,
        maxBlastForce: 30,
        minBlastForce: 15,
        gravity: 0.15,
        colors: const [
          Color(0xFF4CAF50), // Verde elegante
          Color(0xFF2196F3), // Azul profesional
          Color(0xFF9C27B0), // Púrpura premium
          Color(0xFFFF9800), // Naranja cálido
          Color(0xFF00BCD4), // Turquesa moderno
          Color(0xFFE91E63), // Rosa elegante
          Color(0xFF3F51B5), // Índigo profesional
          Color(0xFFFFFFFF), // Blanco puro
          Color(0xFFFFEB3B), // Amarillo dorado
          Color(0xFF8BC34A), // Verde lima
        ],
        createParticlePath: _createElegantParticle,
        minimumSize: const Size(8, 8),
        maximumSize: const Size(16, 16),
      ),
    );
  }
}
