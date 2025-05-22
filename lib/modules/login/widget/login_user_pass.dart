import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/config/config.dart';
import 'package:recetasperuanas/core/constants/option.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
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
            AppTextField(
              hintText: context.loc.enterPassword,
              textEditingController: con.passwordController,
              obscureText: true,
              obscuringCharacter: '*',
              validator: (value) => con.validatePassword(value ?? '', context),
            ),
            AppVerticalSpace.xlg,
            AppButton(
              text: context.loc.login,
              onPressed: () async {
                // if (!_formKeyLogin.currentState!.validate()) return;
                await const LoadingDialog().show(
                  context,
                  future: () async {
                    final isSuccess = await con.login(
                      user: AuthUser(
                        email: 'juan.perez@example.com', // con.emailController.text,
                        contrasena: '123456', // con.passwordController.text,
                        // email: con.emailController.text,
                        // contrasena: con.passwordController.text,
                      ),
                      type: LoginWith.withUserPassword,
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
              showIcon: false,
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
}
