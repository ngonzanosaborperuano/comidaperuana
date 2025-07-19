import 'package:flutter/material.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

/// Widget de prueba para verificar animaciones
class AnimationTestWidget extends StatefulWidget {
  const AnimationTestWidget({super.key});

  @override
  State<AnimationTestWidget> createState() => _AnimationTestWidgetState();
}

class _AnimationTestWidgetState extends State<AnimationTestWidget>
    with TickerProviderStateMixin, StaggeredAnimationMixin {
  @override
  void initState() {
    super.initState();

    // Inicializar animaciones con duraciones más largas para testing
    initializeAnimations(
      fadeDuration: const Duration(milliseconds: 1000),
      slideDuration: const Duration(milliseconds: 800),
      scaleDuration: const Duration(milliseconds: 1000),
      formDuration: const Duration(milliseconds: 1200),
    );

    // Iniciar animaciones escalonadas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startStaggeredAnimations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.background,
      appBar: AppBar(
        title: const Text('Prueba de Animaciones'),
        backgroundColor: context.color.primary,
        foregroundColor: context.color.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo con animación de escala
            RepaintBoundary(
              child: AnimatedScaleWidget(
                animation: scaleAnimation,
                child: AnimatedLogoWidget(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('¡Logo tocado!'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: context.color.primary,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.restaurant, size: 50, color: context.color.background),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Título con animación de entrada
            RepaintBoundary(
              child: AnimatedEntryWidget(
                animation: fadeAnimation,
                slideOffset: const Offset(0, 0.3),
                child: Text(
                  'Animaciones Reutilizables',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: context.color.text,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Descripción con animación fade
            RepaintBoundary(
              child: FadeTransition(
                opacity: fadeAnimation,
                child: Text(
                  'Sistema de animaciones optimizado y reutilizable',
                  style: TextStyle(fontSize: 16, color: context.color.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Botón con animación de presión
            RepaintBoundary(
              child: AnimatedPressButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Botón presionado!'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: context.color.primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      'Presióname',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Widget de pulso
            RepaintBoundary(
              child: AnimatedPulseWidget(
                animation: formAnimation,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: context.color.primary,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(Icons.favorite, size: 40, color: context.color.background),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Widget de rotación
            RepaintBoundary(
              child: AnimatedRotationWidget(
                animation: fadeAnimation,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: context.color.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(Icons.refresh, size: 30, color: context.color.background),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Botón para reiniciar animaciones
            ElevatedButton(
              onPressed: () {
                // Reiniciar todas las animaciones
                fadeController.reset();
                slideController.reset();
                scaleController.reset();
                formController.reset();

                startStaggeredAnimations();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.color.primary,
                foregroundColor: context.color.background,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              child: const Text(
                'Reiniciar Animaciones',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 32),

            // Información de estado de animaciones
            RepaintBoundary(
              child: FadeTransition(
                opacity: fadeAnimation,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.color.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.color.primary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Estado de Animaciones',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: context.color.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fade: ${fadeController.value.toStringAsFixed(2)}\n'
                        'Slide: ${slideController.value.toStringAsFixed(2)}\n'
                        'Scale: ${scaleController.value.toStringAsFixed(2)}\n'
                        'Form: ${formController.value.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 14, color: context.color.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
