import 'package:flutter/material.dart';
import 'package:goncook/common/controller/base_controller.dart';
import 'package:goncook/common/widget/animated_widgets.dart';
import 'package:goncook/common/widget/spacing/spacing.dart' show AppHorizontalSpace;
import 'package:goncook/common/widget/widget.dart' show AppVerticalSpace;

/// Widget de prueba para verificar curvas seguras
class CurveTestWidget extends StatefulWidget {
  const CurveTestWidget({super.key});

  @override
  State<CurveTestWidget> createState() => _CurveTestWidgetState();
}

class _CurveTestWidgetState extends State<CurveTestWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _safeAnimation;
  late Animation<double> _unsafeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    // Animación con curva segura
    _safeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: const SafeCurve(Curves.easeOutBack)));

    // Animación con curva original (para comparar)
    _unsafeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // Iniciar animación
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.background,
      appBar: AppBar(
        title: const Text('Prueba de Curvas Seguras'),
        backgroundColor: context.color.primary,
        foregroundColor: context.color.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Valores de Animación',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.color.text,
              ),
            ),
            AppVerticalSpace.md,

            // Mostrar valores en tiempo real
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final safeValue = _safeAnimation.value;
                final unsafeValue = _unsafeAnimation.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Curva Segura: ${safeValue.toStringAsFixed(4)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: context.color.text,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    AppVerticalSpace.sm,
                    Text(
                      'Curva Original: ${unsafeValue.toStringAsFixed(4)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: context.color.text,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    AppVerticalSpace.sm,
                    Text(
                      'Controlador: ${_controller.value.toStringAsFixed(4)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: context.color.text,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    AppVerticalSpace.md,

                    // Indicadores visuales
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: context.color.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: safeValue,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: context.color.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        AppHorizontalSpace.md,
                        Text(
                          'Segura',
                          style: TextStyle(fontSize: 14, color: context.color.textSecondary),
                        ),
                      ],
                    ),
                    AppVerticalSpace.sm,
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 20,
                            decoration: BoxDecoration(
                              color: context.color.primary.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: unsafeValue.clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: context.color.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        AppHorizontalSpace.md,
                        Text(
                          'Original',
                          style: TextStyle(fontSize: 14, color: context.color.textSecondary),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),

            AppVerticalSpace.lg,

            // Controles
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _controller.repeat();
                  },
                  child: const Text('Repetir'),
                ),
                AppHorizontalSpace.md,
                ElevatedButton(
                  onPressed: () {
                    _controller.stop();
                    _controller.reset();
                  },
                  child: const Text('Reset'),
                ),
                AppHorizontalSpace.md,
                ElevatedButton(
                  onPressed: () {
                    _controller.forward();
                  },
                  child: const Text('Forward'),
                ),
              ],
            ),

            AppVerticalSpace.lg,

            // Información sobre curvas seguras
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.color.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.color.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¿Por qué Curvas Seguras?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.color.text,
                    ),
                  ),
                  AppVerticalSpace.sm,
                  Text(
                    '• Algunas curvas como Curves.elasticOut pueden producir valores fuera del rango [0, 1]\n'
                    '• Esto causa errores críticos en Flutter\n'
                    '• SafeCurve garantiza que todos los valores estén en el rango válido\n'
                    '• Mantiene la suavidad de la animación original',
                    style: TextStyle(fontSize: 14, color: context.color.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
