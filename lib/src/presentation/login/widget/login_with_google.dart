import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/src/presentation/login/controller/login_controller.dart'
    show LoginController;
import 'package:recetasperuanas/src/shared/constants/option.dart';
import 'package:recetasperuanas/src/shared/constants/routes.dart';
import 'package:recetasperuanas/src/shared/controller/base_controller.dart';
import 'package:recetasperuanas/src/shared/widget/widget.dart';

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({super.key, required this.con});
  final LoginController con;

  @override
  Widget build(BuildContext context) {
    return AppButton.google(
      iconAtStart: true,
      isGoogle: true,
      text: 'Google',
      onPressed: () async {
        await const LoadingDialog().show(
          context,
          future: () async {
            final (isSuccess, msg) = await con.login(
              email: con.emailController.text,
              password: con.passwordController.text,
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
