import 'package:flutter/material.dart';
import 'package:goncook/src/shared/controller/base_controller.dart';
import 'package:goncook/src/shared/widget/widget.dart';

class FootPayU extends StatelessWidget {
  const FootPayU({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: AppSpacing.lg,
      ),
      color: context.color.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: AppSpacing.md, color: context.color.textSecondary),
          AppHorizontalSpace.xs,
          Text(
            context.loc.processedByPayuSsl,
            style: TextStyle(fontSize: AppSpacing.sl, color: context.color.textSecondary),
          ),
        ],
      ),
    );
  }
}
