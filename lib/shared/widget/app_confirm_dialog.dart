import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class AppConfirmDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final Color? borderColorFrom;
  final Color? borderColorTo;
  final Color? backgroundColor;
  final bool showAnimatedBorder;

  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.borderColorFrom,
    this.borderColorTo,
    this.backgroundColor,
    this.showAnimatedBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    // Siempre usa el card premium, incluso en iOS
    return _buildMaterial(context);
  }

  Widget _buildMaterial(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final double maxWidth = size.width > 600 ? size.width * 0.45 : size.width;
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.92, end: 1),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutBack,
        builder:
            (context, scale, child) => Opacity(
              opacity: scale.clamp(0, 1),
              child: Transform.scale(scale: scale, child: child),
            ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Dialog(
            backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            elevation: 0,
            child: Stack(
              children: [
                if (showAnimatedBorder)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _BorderBeamPainter(
                          colorFrom: borderColorFrom ?? Theme.of(context).colorScheme.primary,
                          colorTo: borderColorTo ?? Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Título con icono
                      Row(
                        children: [
                          Icon(
                            Icons.subscriptions,
                            color: confirmColor ?? Theme.of(context).colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Contenido flexible
                      content,
                      const SizedBox(height: 24),
                      // Botones
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: onCancel ?? () => Navigator.of(context).pop(),
                              child: Text(
                                cancelLabel,
                                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.color.buttonPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: onConfirm,
                              child: Text(
                                confirmLabel,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: context.color.background,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCupertino(BuildContext context) {
    return CupertinoAlertDialog(
      title: Row(
        children: [
          Icon(
            CupertinoIcons.creditcard,
            color: confirmColor ?? CupertinoColors.activeBlue,
            size: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
        ],
      ),
      content: Padding(padding: const EdgeInsets.only(top: 12), child: content),
      actions: [
        CupertinoDialogAction(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: Text(cancelLabel),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: onConfirm,
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}

// Border-beam painter inspirado en MagicUI
class _BorderBeamPainter extends CustomPainter {
  final Color colorFrom;
  final Color colorTo;
  _BorderBeamPainter({required this.colorFrom, required this.colorTo});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint =
        Paint()
          ..shader = LinearGradient(
            colors: [colorFrom, colorTo, colorFrom],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5;

    final rrect = RRect.fromRectAndRadius(rect.deflate(1.5), const Radius.circular(22));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
