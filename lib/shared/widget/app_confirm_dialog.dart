import 'package:flutter/material.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/spacing/spacing.dart';
import 'package:recetasperuanas/shared/widget/widget.dart' show AppButton;

class AppConfirmDialog extends StatefulWidget {
  final String title;
  final Widget content;
  final String confirmLabel;
  final String? cancelLabel;
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
    this.cancelLabel,
    required this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.borderColorFrom,
    this.borderColorTo,
    this.backgroundColor,
    this.showAnimatedBorder = true,
  });

  @override
  State<AppConfirmDialog> createState() => _AppConfirmDialogState();
}

class _AppConfirmDialogState extends State<AppConfirmDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: widget.backgroundColor ?? context.color.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.xmd),
              side: BorderSide(
                color: context.color.border,
                style: BorderStyle.solid,
              ),
            ),
            elevation: 0,
            child: Stack(
              children: [
                if (widget.showAnimatedBorder)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: _BorderBeamPainter(
                              colorFrom:
                                  widget.borderColorFrom ??
                                  context.color.buttonPrimary,
                              colorTo:
                                  widget.borderColorTo ?? context.color.error,
                              rotation: _controller.value * 2 * 3.1416,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.md,
                  ),
                  child: Column(
                    spacing: AppSpacing.md,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.subscriptions,
                            color: context.color.buttonPrimary,
                            size: 28,
                          ),
                          AppHorizontalSpace.sm,
                          Expanded(
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppSpacing.xmd,
                              ),
                            ),
                          ),
                        ],
                      ),
                      widget.content,
                      Row(
                        children: [
                          if (widget.cancelLabel != null) ...[
                            Expanded(
                              child: TextButton(
                                onPressed:
                                    widget.onCancel ??
                                    () => Navigator.of(context).pop(),
                                child: Text(
                                  widget.cancelLabel!,
                                  style: TextStyle(color: context.color.text),
                                ),
                              ),
                            ),
                            AppHorizontalSpace.sm,
                          ],
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              child: AppButton(
                                onPressed: widget.onConfirm,
                                text: widget.confirmLabel,
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
}

class _BorderBeamPainter extends CustomPainter {
  final Color colorFrom;
  final Color colorTo;
  final double rotation;
  _BorderBeamPainter({
    required this.colorFrom,
    required this.colorTo,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint =
        Paint()
          ..shader = SweepGradient(
            colors: [colorFrom, colorTo, colorFrom],
            stops: const [0.0, 0.5, 1.0],
            transform: GradientRotation(rotation),
          ).createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;

    final rrect = RRect.fromRectAndRadius(
      rect.deflate(1.5),
      const Radius.circular(AppSpacing.xmd),
    );
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _BorderBeamPainter oldDelegate) =>
      oldDelegate.rotation != rotation ||
      oldDelegate.colorFrom != colorFrom ||
      oldDelegate.colorTo != colorTo;
}
