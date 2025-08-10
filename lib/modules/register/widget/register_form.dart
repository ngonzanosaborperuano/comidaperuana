import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/auth/models/auth_user.dart';
import 'package:recetasperuanas/core/config/style/app_styles.dart';
import 'package:recetasperuanas/modules/login/widget/widget.dart' show LogoWidget;
// Controller eliminado tras migración a BLoC
import 'package:recetasperuanas/modules/register/widget/animated_register_button.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

import '../../../shared/widget/animated_widgets.dart' show AnimatedLogoWidget;

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key, required this.formKey, required this.onRegister});

  final GlobalKey<FormState> formKey;
  final Future<void> Function(AuthUser user) onRegister;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

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
            textEditingController: _fullNameController,
            keyboardType: TextInputType.name,
            validator: (value) => _validateNotEmpty(value, context),
            prefixIcon: Icon(Icons.person, color: context.color.textSecondary),
          ),
          AppVerticalSpace.xmd,
          AppTextField(
            hintText: context.loc.enterEmail,
            textEditingController: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => _validateEmail(value, context),
            prefixIcon: Icon(Icons.email, color: context.color.textSecondary),
          ),
          AppVerticalSpace.xmd,
          _RegisterPasswordField(passwordController: _passwordController),
          AppVerticalSpace.xmd,
          AnimatedRegisterButton(isLoading: _isLoading, onPressed: () => _handleRegister(context)),
        ],
      ),
    );
  }

  String? _validateNotEmpty(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) return context.loc.validateEmpty;
    return null;
  }

  String? _validateEmail(String? value, BuildContext context) {
    if (value == null || value.isEmpty) return context.loc.validateEmpty;
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) return 'El formato del email no es válido';
    return null;
  }

  Future<void> _handleRegister(BuildContext context) async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = AuthUser(
        email: _emailController.text,
        contrasena: _passwordController.text,
        nombreCompleto: _fullNameController.text,
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

class _RegisterPasswordField extends StatefulWidget {
  const _RegisterPasswordField({required this.passwordController});

  final TextEditingController passwordController;

  @override
  State<_RegisterPasswordField> createState() => _RegisterPasswordFieldState();
}

class _RegisterPasswordFieldState extends State<_RegisterPasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          hintText: context.loc.enterPassword,
          textEditingController: widget.passwordController,
          obscureText: _isObscure,
          obscuringCharacter: '*',
          validator: (value) => _validatePassword(value, context),
          prefixIcon: Icon(Icons.lock, color: context.color.textSecondary),
        ),
        TextButton(
          onPressed: () => setState(() => _isObscure = !_isObscure),
          child: Text(
            _isObscure ? context.loc.showPassword : context.loc.hidePassword,
            style: AppStyles.bodyTextBold.copyWith(color: context.color.text),
          ),
        ),
      ],
    );
  }

  String? _validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) return context.loc.validateEmpty;
    if (value.length < 8) return 'La contraseña debe tener al menos 8 caracteres';
    if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) return 'Debe contener al menos una mayúscula';
    if (!RegExp(r'^(?=.*[a-z])').hasMatch(value)) return 'Debe contener al menos una minúscula';
    if (!RegExp(r'^(?=.*\\d)').hasMatch(value)) return 'Debe contener al menos un número';
    return null;
  }
}
