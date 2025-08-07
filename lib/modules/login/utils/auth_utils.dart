import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/auth/models/auth_user.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart'
    show LoginController;

Future<void> handleLogin({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required LoginController controller,
  required Function(AuthUser) onLogin,
  required VoidCallback setLoadingTrue,
  required VoidCallback setLoadingFalse,
}) async {
  if (!formKey.currentState!.validate()) return;
  setLoadingTrue();
  try {
    final user = AuthUser(
      email: controller.emailController.text,
      contrasena: controller.passwordController.text,
    );
    await onLogin(user);
  } finally {
    setLoadingFalse();
  }
}
