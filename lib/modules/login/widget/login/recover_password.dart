import 'package:flutter/material.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/animated_widgets.dart' show AnimatedEntryWidget;

class RecoverPassword extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onTap;
  final BuildContext context;

  const RecoverPassword({
    super.key,
    required this.animation,
    required this.onTap,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedEntryWidget(
        animation: animation,
        slideOffset: const Offset(0, 0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: onTap,
              child: Text(
                this.context.loc.recoverEmail,
                style: TextStyle(color: this.context.color.buttonPrimary, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
