import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';

import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/spacing/spacing.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final GlobalKey<FormState> _formKeyLogin;

  @override
  void initState() {
    _formKeyLogin = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (_, LoginController con, __) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Logo(),
                  AppVerticalSpace.md,
                  AppText(
                    text: context.loc.login,
                    fontSize: AppSpacing.xmd,
                    fontWeight: FontWeight.bold,
                  ),
                  AppVerticalSpace.md,
                  AppButton(
                    rounded: true,
                    text: 'Google',
                    onPressed: () {},
                    showIcon: true,
                    iconWidget: Image.asset(
                      'assets/img/google.png',
                      width: 20,
                      height: 20,
                    ),
                    isAlternative: true,
                  ),
                  AppVerticalSpace.md,
                  DividerWidget(),
                  AppText(
                    text: context.loc.descriptionLogin,
                    fontSize: AppSpacing.md,
                    fontWeight: FontWeight.w400,
                  ),
                  FormLogin(formKeyLogin: _formKeyLogin, con: con),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FormLogin extends StatelessWidget {
  const FormLogin({
    super.key,
    required GlobalKey<FormState> formKeyLogin,
    required this.con,
  }) : _formKeyLogin = formKeyLogin;

  final GlobalKey<FormState> _formKeyLogin;
  final LoginController con;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKeyLogin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppVerticalSpace.sm,
          AppText(text: context.loc.email),
          AppVerticalSpace.sm,
          AppTextField(
            hintText: context.loc.enterEmail,
            textEditingController: con.emailController,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9@.]')),
            ],

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
              if (!_formKeyLogin.currentState!.validate()) return;

              await const LoadingDialog().show(
                context,
                future: () async {
                  final isSuccess = await con.login(
                    AuthUser(
                      email: con.emailController.text,
                      password: con.passwordController.text,
                    ),
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
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo',
      child: ClipOval(
        child: Image.asset('assets/img/logo.png', width: 150, height: 150),
      ),
    );
  }
}
