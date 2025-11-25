import 'package:flutter/material.dart';
import 'package:goncook/src/infrastructure/auth/models/auth_user.dart';
import 'package:goncook/src/presentation/login/controller/login_controller.dart'
    show LoginController;
import 'package:goncook/src/presentation/login/helpers/auth_modals.dart'
    show showRecoverPasswordDialog;
import 'package:goncook/src/presentation/login/utils/auth_utils.dart' show handleLogin;
import 'package:goncook/src/presentation/login/widget/login/login.dart';
import 'package:goncook/src/shared/widget/animated_widgets.dart';
import 'package:goncook/src/shared/widget/widget.dart';

class AnimatedLoginForm extends StatefulWidget {
  const AnimatedLoginForm({
    super.key,
    required this.formKey,
    required this.controller,
    required this.onLogin,
    required this.animation,
  });

  final GlobalKey<FormState> formKey;
  final LoginController controller;
  final Function(AuthUser) onLogin;
  final Animation<double> animation;

  @override
  State<AnimatedLoginForm> createState() => _AnimatedLoginFormState();
}

class _AnimatedLoginFormState extends State<AnimatedLoginForm> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedEntryWidget(
      animation: widget.animation,
      slideOffset: const Offset(0, 0.2),
      child: Form(
        key: widget.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.md,
          children: [
            LogoLogin(animation: widget.animation),
            HeaderAndSubTitle(widget: widget),
            EmailLogin(widget: widget),
            PasswordLogin(widget: widget),
            LoginButton(
              isLoading: _isLoading,
              onPressed: _isLoading
                  ? null
                  : () => handleLogin(
                      context: context,
                      formKey: widget.formKey,
                      controller: widget.controller,
                      onLogin: widget.onLogin,
                      setLoadingTrue: () => setState(() => _isLoading = true),
                      setLoadingFalse: () => setState(() => _isLoading = false),
                    ),
              context: context,
            ),
            RecoverPassword(
              animation: widget.animation,
              onTap: () =>
                  showRecoverPasswordDialog(context: context, controller: widget.controller),
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
