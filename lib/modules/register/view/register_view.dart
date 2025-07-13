import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/config/style/app_styles.dart';
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
      padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
      child: SingleChildScrollView(
        child: Consumer<RegisterController>(
          builder: (_, RegisterController con, _) {
            return SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.go(Routes.login.description);
                        },
                        icon: Icon(Icons.arrow_back, color: context.color.text),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: context.color.textSecondary2Invert,
                    child: Icon(Icons.person_add, size: 30, color: context.color.background),
                  ),
                  AppVerticalSpace.md,
                  AppText(
                    text: context.loc.registerNow,
                    fontSize: AppSpacing.xxmd,
                    fontWeight: FontWeight.bold,
                    color: context.color.text,
                    textAlign: TextAlign.center,
                  ),
                  AppVerticalSpace.md,
                  AppText(
                    text: context.loc.completeInformation,
                    fontSize: AppSpacing.md,
                    fontWeight: FontWeight.w400,
                    textAlign: TextAlign.center,
                  ),
                  Form(
                    key: _formKeyRegister,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppVerticalSpace.xlg,
                        AppTextField(
                          hintText: context.loc.enterFullName,
                          textEditingController: con.fullNameController,
                          keyboardType: TextInputType.name,
                          validator: (value) => con.validateEmpty(value ?? '', context),
                          prefixIcon: Icon(Icons.person, color: context.color.textSecondary),
                        ),
                        AppVerticalSpace.xmd,
                        AppTextField(
                          hintText: context.loc.enterEmail,
                          textEditingController: con.emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) => con.validateEmail(value ?? '', context),
                          prefixIcon: Icon(Icons.email, color: context.color.textSecondary),
                        ),
                        AppVerticalSpace.xmd,
                        TextPassword(con: con),
                        AppVerticalSpace.xmd,
                        AppButton(
                          text: context.loc.register,
                          onPressed: () => showAdaptiveDialoga(context: context, con: con),
                          showIcon: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
    if (!context.mounted) return;
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

class TextPassword extends StatelessWidget {
  const TextPassword({super.key, required this.con});
  final RegisterController con;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: con.isObscureText,
      builder: (BuildContext context, value, Widget? child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              hintText: context.loc.enterPassword,
              textEditingController: con.passwordController,
              obscureText: value,
              obscuringCharacter: '*',
              validator: (value) => con.validatePassword(value ?? '', context),
              prefixIcon: Icon(Icons.lock, color: context.color.textSecondary),
            ),
            TextButton(
              onPressed: () {
                con.isObscureText.value = !con.isObscureText.value;
              },
              child: Text(
                con.isObscureText.value ? context.loc.showPassword : context.loc.hidePassword,
                style: AppStyles.bodyTextBold.copyWith(color: context.color.text),
              ),
            ),
          ],
        );
      },
    );
  }
}
