import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

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

  Future<void> _handleLogin() async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = AuthUser(
        email: widget.controller.emailController.text,
        contrasena: widget.controller.passwordController.text,
      );

      await widget.onLogin(user);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showRecoverPasswordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: context.color.background,
      builder: (context) {
        TextEditingController textEditingController = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 15,
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.4,
              child: Column(
                children: [
                  AppText(text: context.loc.recoverPassword, fontWeight: FontWeight.bold),
                  AppVerticalSpace.md,
                  AppText(text: context.loc.recoverAccountMessage),
                  AppVerticalSpace.lg,
                  AppTextField(
                    hintText: context.loc.email,
                    textEditingController: textEditingController,
                  ),
                  AppVerticalSpace.xmd,
                  _buttonRecoveriPass(context, textEditingController),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppButton _buttonRecoveriPass(BuildContext context, TextEditingController textEditingController) {
    return AppButton(
      text: context.loc.send,
      onPressed: () async {
        await const LoadingDialog().show(
          context,
          future: () async {
            final msg = await widget.controller.recoverCredential(textEditingController.text);
            if (!context.mounted) return;
            switch (msg) {
              case 'success':
                context.showSuccessToast('Correo de recuperación enviado con éxito.');
                break;
              case 'invalid-email':
                _snackBar(context, context.loc.errorInvalidEmail);
                break;
              case 'user-not-found':
                _snackBar(context, context.loc.errorUserNotFound);
                break;
              case 'too-many-requests':
                _snackBar(context, context.loc.errorTooManyRequests);
                break;
              case 'network-request-failed':
                _snackBar(context, context.loc.errorNetwork);
                break;
              default:
                _snackBar(context, context.loc.errorDefault);
                break;
            }
          },
        );
      },
    );
  }

  void _snackBar(BuildContext context, String message) {
    context.showErrorToast(message);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedEntryWidget(
      animation: widget.animation,
      slideOffset: const Offset(0, 0.2),
      child: RepaintBoundary(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.color.background,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: context.color.textSecondary.withValues(alpha: 0.2),
                blurRadius: 15,
                spreadRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Form(
            key: widget.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Campo de email
                RepaintBoundary(
                  child: AnimatedEntryWidget(
                    animation: widget.animation,
                    slideOffset: const Offset(-0.3, 0),
                    child: AppTextField(
                      textEditingController: widget.controller.emailController,
                      hintText: context.loc.email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => widget.controller.validateEmail(value ?? '', context),
                    ),
                  ),
                ),

                AppVerticalSpace.md,

                // Campo de contraseña
                RepaintBoundary(
                  child: AnimatedEntryWidget(
                    animation: widget.animation,
                    slideOffset: const Offset(0.3, 0),
                    child: AppTextField(
                      textEditingController: widget.controller.passwordController,
                      hintText: context.loc.password,
                      obscureText: true,
                      validator:
                          (value) => widget.controller.validatePassword(value ?? '', context),
                    ),
                  ),
                ),

                AppVerticalSpace.md,

                // Botón de login
                RepaintBoundary(
                  child: AppButton(
                    text: _isLoading ? '${context.loc.login}...' : context.loc.login,
                    onPressed: _isLoading ? null : _handleLogin,
                    showIcon: false,
                    enabledButton: !_isLoading,
                  ),
                ),

                AppVerticalSpace.md,

                // Enlaces adicionales
                RepaintBoundary(
                  child: AnimatedEntryWidget(
                    animation: widget.animation,
                    slideOffset: const Offset(0, 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _showRecoverPasswordModal(context);
                          },
                          child: Text(
                            context.loc.recoverEmail,
                            style: TextStyle(color: context.color.buttonPrimary, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
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
