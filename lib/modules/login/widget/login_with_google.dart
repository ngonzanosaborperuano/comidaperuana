import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/constants/option.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({super.key, required this.con});
  final LoginController con;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      iconAtStart: true,
      isGoogle: true,
      text: 'Google',
      onPressed: () async {
        await const LoadingDialog().show(
          context,
          future: () async {
            final (isSuccess, msg) = await con.login(
              user: AuthUser(
                email: con.emailController.text,
                contrasena: con.passwordController.text,
              ),
              type: LoginWith.withGoogle,
            );

            if (isSuccess) {
              if (!context.mounted) return;
              context.showSuccessToast(context.loc.welcomeToCocinandoIA);
              context.go(Routes.home.description);
            } else {
              var mensageUser = '';
              if (!context.mounted) return;
              if (msg == 'account-exists-with-different-credential') {
                mensageUser = context.loc.accountExistsWithDifferentCredential;
              } else if (msg == 'invalid-credential') {
                mensageUser = context.loc.invalidCredential;
              } else if (msg == 'operation-not-allowed') {
                mensageUser = context.loc.operationNotAllowed;
              } else if (msg == 'user-disabled') {
                mensageUser = context.loc.userDisabled;
              } else if (msg == 'user-not-found') {
                mensageUser = context.loc.userNotFound;
              } else if (msg == 'wrong-password') {
                mensageUser = context.loc.wrongPassword;
              } else {
                mensageUser = context.loc.authError;
              }
              await showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return AppModalAlert(
                    text: mensageUser,
                    title: context.loc.titleAccessDenied,
                    maxHeight: 200,
                    icon: Icons.error,
                    labelButton: context.loc.accept,
                    onPressed: context.pop,
                  );
                },
              );
            }
          },
        );
      },
      showIcon: true,
      iconWidget: Image.asset('assets/img/google.png', width: 20, height: 20),
    );
  }
}
