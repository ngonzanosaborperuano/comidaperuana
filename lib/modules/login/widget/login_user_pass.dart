import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/config/config.dart';
import 'package:recetasperuanas/core/constants/option.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart';
import 'package:recetasperuanas/modules/login/widget/text_field_password.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/utils/util.dart';
import 'package:recetasperuanas/shared/widget/spacing/spacing.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

class LoginUserPass extends StatelessWidget {
  const LoginUserPass({super.key, required GlobalKey<FormState> formKeyLogin, required this.con})
    : _formKeyLogin = formKeyLogin;

  final GlobalKey<FormState> _formKeyLogin;
  final LoginController con;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKeyLogin,
      child: Material(
        child: ExpansionTile(
          leading: Icon(Icons.person_3_rounded, color: context.color.secondary),
          title: Text(
            context.loc.userPass,
            style: AppStyles.bodyTextBold.copyWith(color: context.color.secondary),
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,
          trailing: Icon(Icons.arrow_drop_down, color: context.color.secondary),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          collapsedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          collapsedBackgroundColor: context.color.textSecundary,
          backgroundColor: context.color.textSecundary,
          childrenPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children: [
            AppVerticalSpace.sm,
            AppText(text: context.loc.email),
            AppVerticalSpace.sm,
            AppTextField(
              hintText: context.loc.enterEmail,
              textEditingController: con.emailController,
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9@.]'))],

              validator: (value) => con.validateEmail(value ?? '', context),
            ),
            AppVerticalSpace.xmd,
            AppText(text: context.loc.password),
            AppVerticalSpace.sm,
            TextFieldPassword(con: con),
            AppVerticalSpace.xlg,
            AppButton(
              text: context.loc.login,
              onPressed: () async {
                if (!_formKeyLogin.currentState!.validate()) return;
                await const LoadingDialog().show(
                  context,
                  future: () async {
                    var mensageUser = '';
                    final (isSuccess, msg) = await con.login(
                      user: AuthUser(
                        email: con.emailController.text,
                        contrasena: con.passwordController.text,
                      ),
                      type: LoginWith.withUserPassword,
                    );

                    if (isSuccess) {
                      if (!context.mounted) {
                        return (false, 'Context is not mounted.');
                      }
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
                      } else if (msg == 'account-exists-with-different-credential') {
                        mensageUser = context.loc.accountExistsWithDifferentCredential;
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
              showIcon: false,
            ),
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  isScrollControlled: true,
                  backgroundColor: context.color.textSecundary,
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
                              AppText(
                                text: context.loc.recoverPassword,
                                fontWeight: FontWeight.bold,
                              ),
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
              },
              child: Text(
                context.loc.recoverEmail,
                style: TextStyle(color: context.color.secondary, fontSize: 18),
              ),
            ),
            AppVerticalSpace.md,
            AppButton(
              text: context.loc.register,
              onPressed: () {
                context.go(Routes.register.description);
              },
              isAlternative: true,
            ),
          ],
        ),
      ),
    );
  }

  AppButton _buttonRecoveriPass(BuildContext context, TextEditingController textEditingController) {
    return AppButton(
      text: context.loc.send,
      onPressed: () async {
        await const LoadingDialog().show(
          context,
          future: () async {
            final msg = await con.recoverCredential(textEditingController.text);
            if (!context.mounted) return;
            switch (msg) {
              case 'success':
                showCustomSnackBar(
                  context: context,
                  message: 'Correo de recuperación enviado con éxito.',
                  backgroundColor: context.color.success,
                  foregroundColor: context.color.textPrimary,
                );

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
      // isAlternative: true,
    );
  }

  void _snackBar(BuildContext context, String message) {
    return showCustomSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.error,
      foregroundColor: AppColors.white,
    );
  }
}
