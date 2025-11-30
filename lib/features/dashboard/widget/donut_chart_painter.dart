import 'package:flutter/material.dart';
import 'package:goncook/features/core/config/color/app_color_scheme.dart';
import 'package:goncook/features/core/config/config.dart';

class AppDonutChart extends StatefulWidget {
  final double completedPercent;

  const AppDonutChart({super.key, required this.completedPercent});

  @override
  State<AppDonutChart> createState() => _AppDonutChartState();
}

class _AppDonutChartState extends State<AppDonutChart> {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: widget.completedPercent.clamp(0.0, 1.0)),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        return SizedBox(
          height: 150,
          width: 150,
          child: CustomPaint(
            painter: DonutChartPainter(animatedValue, context),
            child: Center(
              child: Text(
                '${(animatedValue * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        );
      },
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final double completedPercent;
  final BuildContext context;

  DonutChartPainter(this.completedPercent, this.context);

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 20.0;
    final radius = (size.width / 2) - strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius * (2 * completedPercent));

    final backgroundPaint = Paint()
      ..color = AppColors.slate200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final completedPaint = Paint()
      ..color = AppColorScheme.of(context).success
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, 2 * 3.1416, false, backgroundPaint);

    canvas.drawArc(rect, -3.1416 / 2, 2 * 3.1416 * completedPercent, false, completedPaint);
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) =>
      oldDelegate.completedPercent != completedPercent;
}
