import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/common/widget/animated_widgets.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/features/auth/controller/login_controller.dart' show LoginController;
import 'package:goncook/features/auth/data/models/auth_user.dart';
import 'package:goncook/features/auth/helpers/auth_modals.dart' show showRecoverPasswordDialog;
import 'package:goncook/features/auth/presentation/bloc/login_bloc.dart';
import 'package:goncook/features/auth/presentation/widget/login/login.dart';

/// Login form widget that manages state through BLoC.
///
/// This StatelessWidget uses BLoC to manage loading state instead of
/// local state, eliminating the need for StatefulWidget.
class AnimatedLoginForm extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return AnimatedEntryWidget(
          animation: animation,
          slideOffset: const Offset(0, 0.2),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.md,
              children: [
                LogoLogin(animation: animation),
                HeaderAndSubTitle(widget: this),
                EmailLogin(widget: this),
                PasswordLogin(widget: this),
                LoginButton(
                  isLoading: isLoading,
                  onPressed: isLoading
                      ? null
                      : () => _handleLogin(
                            context: context,
                            formKey: formKey,
                            controller: controller,
                            onLogin: onLogin,
                          ),
                  context: context,
                ),
                RecoverPassword(
                  animation: animation,
                  onTap: () => showRecoverPasswordDialog(
                    context: context,
                    controller: controller,
                  ),
                  context: context,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleLogin({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required LoginController controller,
    required Function(AuthUser) onLogin,
  }) async {
    if (!formKey.currentState!.validate()) return;

    final user = AuthUser(
      email: controller.emailController.text,
      contrasena: controller.passwordController.text,
    );
    await onLogin(user);
  }
}
