import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/core/constants/option.dart' show LoginWith;
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller_old.dart'
    show LoginController;
import 'package:recetasperuanas/modules/login/widget/widget.dart'
    show AnimatedLoginForm;
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/widget.dart'
    show LoadingDialog, AppToastExtension, AppModalAlert, AppSpacing, AppText;

import 'login_with_google.dart' show LoginWithGoogle;

class FormLogin extends StatelessWidget {
  const FormLogin({
    super.key,
    required this.maxWidth,
    required GlobalKey<FormState> formKeyLogin,
    required this.formAnimation,
    required this.con,
  }) : _formKeyLogin = formKeyLogin;

  final double maxWidth;
  final GlobalKey<FormState> _formKeyLogin;
  final Animation<double> formAnimation;
  final LoginController con;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.color.background,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: context.color.textSecondary.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: AppSpacing.md,
            children: [
              AnimatedLoginForm(
                formKey: _formKeyLogin,
                controller: con,
                animation: formAnimation,
                onLogin: (user) async {
                  await const LoadingDialog().show(
                    context,
                    future: () async {
                      var mensageUser = '';
                      final (isSuccess, msg) = await con.login(
                        user: user,
                        type: LoginWith.withUserPassword,
                      );
                      if (isSuccess) {
                        if (!context.mounted) {
                          return (false, 'Context is not mounted.');
                        }
                        context.showSuccessToast(
                          context.loc.welcomeToCocinandoIA,
                        );
                        context.go(Routes.home.description);
                      } else {
                        if (!context.mounted) {
                          return (false, 'Context is not mounted.');
                        }
                        if (msg == 'weak-password') {
                          mensageUser = context.loc.weakPassword;
                        } else if (msg == 'email-already-in-use') {
                          mensageUser = context.loc.emailAlreadyInUse;
                        } else if (msg == 'user-not-found') {
                          mensageUser = context.loc.userNotFound;
                        } else if (msg == 'wrong-password') {
                          mensageUser = context.loc.wrongPassword;
                        } else if (msg == 'user-disabled') {
                          mensageUser = context.loc.userDisabled;
                        } else if (msg == 'operation-not-allowed') {
                          mensageUser = context.loc.operationNotAllowed;
                        } else if (msg ==
                            'account-exists-with-different-credential') {
                          mensageUser =
                              context.loc.accountExistsWithDifferentCredential;
                        } else if (msg == 'invalid-credential') {
                          mensageUser = context.loc.invalidCredential;
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
              ),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      context.loc.or,
                      style: TextStyle(color: context.color.textSecondary),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              LoginWithGoogle(con: con),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: context.loc.dontHaveAccount,
                    fontSize: AppSpacing.md,
                    fontWeight: FontWeight.w400,
                    color: context.color.text,
                  ),
                  TextButton(
                    onPressed: () {
                      context.go(Routes.register.description);
                    },
                    child: AppText(
                      text: context.loc.register,
                      fontSize: AppSpacing.md,
                      fontWeight: FontWeight.w400,
                      color: context.color.buttonPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
