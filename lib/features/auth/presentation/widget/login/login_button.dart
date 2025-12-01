import 'package:flutter/material.dart';
import 'package:goncook/common/extension/extension.dart';
import 'package:goncook/common/widget/widget.dart';

class LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final BuildContext context;

  const LoginButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AppButton(
        text: isLoading ? '${this.context.loc.login}...' : this.context.loc.login,
        onPressed: onPressed,
        showIcon: false,
        enabledButton: !isLoading,
      ),
    );
  }
}
