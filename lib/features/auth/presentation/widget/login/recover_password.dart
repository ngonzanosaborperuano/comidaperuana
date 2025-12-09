import 'package:flutter/material.dart';
import 'package:goncook/core/extension/extension.dart';

class RecoverPassword extends StatelessWidget {
  final VoidCallback onTap;
  final BuildContext context;

  const RecoverPassword({super.key, required this.onTap, required this.context});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
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
    );
  }
}
