import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/modules/register/controller/register_controller.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/spacing/spacing.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final GlobalKey<FormState> _formKeyRegister;
  @override
  void initState() {
    _formKeyRegister = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Consumer<RegisterController>(
          builder: (_, RegisterController con, __) {
            return Column(
              children: [
                Hero(
                  tag: 'logo',
                  child: ClipOval(
                    child: Image.asset('assets/img/logoOutName.png', width: 200, height: 200),
                  ),
                ),
                AppVerticalSpace.md,
                AppText(
                  text: context.loc.registerNow,
                  fontSize: AppSpacing.xmd,
                  fontWeight: FontWeight.bold,
                ),

                AppText(
                  text: context.loc.completeInformation,
                  fontSize: AppSpacing.md,
                  fontWeight: FontWeight.w400,
                ),
                Form(
                  key: _formKeyRegister,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppVerticalSpace.xlg,
                      AppText(text: context.loc.fullName),
                      AppVerticalSpace.sm,
                      AppTextField(
                        hintText: context.loc.enterFullName,
                        textEditingController: con.fullNameController,
                        keyboardType: TextInputType.name,
                        validator: (value) => con.validateEmpty(value ?? '', context),
                      ),
                      AppVerticalSpace.xmd,
                      AppText(text: context.loc.email),
                      AppVerticalSpace.sm,
                      AppTextField(
                        hintText: context.loc.enterEmail,
                        textEditingController: con.emailController,
                        keyboardType: TextInputType.emailAddress,
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
                      AppVerticalSpace.xmd,
                      AppText(text: context.loc.repeatPassword),
                      AppVerticalSpace.sm,
                      AppTextField(
                        hintText: context.loc.enterPassword,
                        textEditingController: con.repeatController,
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) => con.validatePassword(value ?? '', context),
                      ),
                      AppVerticalSpace.xlg,
                      AppButton(
                        text: context.loc.register,
                        onPressed: () => showAdaptiveDialoga(context: context, con: con),

                        showIcon: false,
                      ),
                      AppVerticalSpace.xmd,
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> showAdaptiveDialoga({
    required BuildContext context,
    required RegisterController con,
  }) async {
    if (!_formKeyRegister.currentState!.validate()) return;
    if (con.passwordController.text != con.repeatController.text) {
      if (!context.mounted) return;
      await showAdaptiveDialog(
        context: context,
        builder: (context) {
          return AppModalAlert(
            text: context.loc.validatePasswordText,
            title: context.loc.error,
            maxHeight: 200,
            icon: Icons.error,
            labelButton: context.loc.accept,
            onPressed: context.pop,
          );
        },
      );
      return;
    }
    await const LoadingDialog().show(
      context,
      future: () async {
        final isSuccess = await con.register(
          AuthUser(
            email: con.emailController.text,
            contrasena: con.passwordController.text,
            nombreCompleto: con.fullNameController.text,
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
  }
}
