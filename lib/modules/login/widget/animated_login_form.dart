import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart';
import 'package:recetasperuanas/modules/login/widget/widget.dart' show LogoWidget;
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/animated_widgets.dart';
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
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        TextEditingController textEditingController = TextEditingController();
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: context.color.background,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Efecto de borde animado tipo border-beam
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _BorderBeamPainter(
                          colorFrom: context.color.buttonPrimary,
                          colorTo: context.color.error,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              context.color.buttonPrimary.withOpacity(0.18),
                              context.color.buttonPrimary.withOpacity(0.08),
                            ],
                          ),
                        ),
                        child: Icon(Icons.lock_reset, color: context.color.buttonPrimary, size: 32),
                      ),
                      const SizedBox(height: 12),
                      AppText(
                        text: context.loc.recoverPassword,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      AppText(
                        text: context.loc.recoverAccountMessage,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: context.color.textSecondary,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Divider(color: context.color.textSecondary.withOpacity(0.08)),
                      const SizedBox(height: 16),
                      AppTextField(
                        hintText: context.loc.email,
                        textEditingController: textEditingController,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: _buttonRecoveriPass(context, textEditingController),
                      ),
                    ],
                  ),
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
                AppVerticalSpace.xmd,
                RepaintBoundary(
                  child: AnimatedScaleWidget(
                    animation: widget.animation,
                    child: const AnimatedLogoWidget(child: Hero(tag: 'logo', child: LogoWidget())),
                  ),
                ),

                AppVerticalSpace.md,
                RepaintBoundary(
                  child: AnimatedEntryWidget(
                    animation: widget.animation,
                    slideOffset: const Offset(0, 0.2),
                    child: AppText(
                      text: context.loc.login,
                      fontSize: AppSpacing.xxmd,
                      fontWeight: FontWeight.bold,
                      color: context.color.text,
                    ),
                  ),
                ),

                AppVerticalSpace.md,
                RepaintBoundary(
                  child: FadeTransition(
                    opacity: widget.animation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppText(
                        text: context.loc.descriptionLogin,
                        fontSize: AppSpacing.md,
                        fontWeight: FontWeight.w400,
                        color: context.color.text,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                AppVerticalSpace.xmd,
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

// Efecto de borde animado tipo border-beam (MagicUI)
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

    final rrect = RRect.fromRectAndRadius(rect.deflate(1.5), const Radius.circular(28));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
