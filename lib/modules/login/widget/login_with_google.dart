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
      rounded: true,
      text: 'Google',
      onPressed: () async {
        await const LoadingDialog().show(
          context,
          future: () async {
            final isSuccess = await con.login(
              user: AuthUser(
                email: con.emailController.text,
                contrasena: con.passwordController.text,
              ),
              type: LoginWith.withGoogle,
            );

            if (isSuccess ?? false) {
              if (!context.mounted) return;
              context.go(Routes.home.description);
            } else {
              if (!context.mounted) return;

              await showAdaptiveDialog(
                context: context,
                builder: (context) {
                  return AppModalAlert(
                    text: context.loc.textAccessDenied,
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
      iconWidget: Image.asset('assets/img/google.png', width: 30, height: 30),
      isAlternative: true,
    );
  }
}
