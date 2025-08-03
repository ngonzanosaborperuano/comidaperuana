import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/config/style/app_styles.dart';
import 'package:recetasperuanas/modules/login/widget/widget.dart' show LogoWidget;
import 'package:recetasperuanas/modules/register/controller/register_controller.dart';
import 'package:recetasperuanas/modules/register/widget/animated_register_button.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

import '../../../shared/widget/animated_widgets.dart' show AnimatedLogoWidget;

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.formKey,
    required this.controller,
    required this.onRegister,
  });

  final GlobalKey<FormState> formKey;
  final RegisterController controller;
  final Future<void> Function(AuthUser user) onRegister;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AnimatedLogoWidget(child: Hero(tag: 'logo', child: LogoWidget())),
          AppVerticalSpace.xlg,
          AppTextField(
            hintText: context.loc.enterFullName,
            textEditingController: widget.controller.fullNameController,
            keyboardType: TextInputType.name,
            validator: (value) => widget.controller.validateEmpty(value ?? '', context),
            prefixIcon: Icon(Icons.person, color: context.color.textSecondary),
          ),
          AppVerticalSpace.xmd,
          AppTextField(
            hintText: context.loc.enterEmail,
            textEditingController: widget.controller.emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => widget.controller.validateEmail(value ?? '', context),
            prefixIcon: Icon(Icons.email, color: context.color.textSecondary),
          ),
          AppVerticalSpace.xmd,
          _RegisterPasswordField(controller: widget.controller),
          AppVerticalSpace.xmd,
          AnimatedRegisterButton(isLoading: _isLoading, onPressed: () => _handleRegister(context)),
        ],
      ),
    );
  }

  Future<void> _handleRegister(BuildContext context) async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = AuthUser(
        email: widget.controller.emailController.text,
        contrasena: widget.controller.passwordController.text,
        nombreCompleto: widget.controller.fullNameController.text,
      );

      await widget.onRegister(user);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class _RegisterPasswordField extends StatelessWidget {
  const _RegisterPasswordField({required this.controller});

  final RegisterController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.isObscureText,
      builder: (BuildContext context, value, Widget? child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              hintText: context.loc.enterPassword,
              textEditingController: controller.passwordController,
              obscureText: value,
              obscuringCharacter: '*',
              validator: (value) => controller.validatePassword(value ?? '', context),
              prefixIcon: Icon(Icons.lock, color: context.color.textSecondary),
            ),
            TextButton(
              onPressed: () {
                controller.isObscureText.value = !controller.isObscureText.value;
              },
              child: Text(
                controller.isObscureText.value
                    ? context.loc.showPassword
                    : context.loc.hidePassword,
                style: AppStyles.bodyTextBold.copyWith(color: context.color.text),
              ),
            ),
          ],
        );
      },
    );
  }
}
