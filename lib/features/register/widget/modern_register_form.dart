import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/core/extension/extension.dart';
import 'package:goncook/features/auth/data/models/auth_model.dart';

class ModernRegisterForm extends StatefulWidget {
  const ModernRegisterForm({super.key, required this.onRegister});

  final Future<void> Function(AuthModel user) onRegister;

  @override
  State<ModernRegisterForm> createState() => _ModernRegisterFormState();
}

class _ModernRegisterFormState extends State<ModernRegisterForm> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AnimatedHeaderWidget(),
          AppVerticalSpace.xlg,
          InputFieldsWidget(
            showPassword: _showPassword,
            fullNameController: _fullNameController,
            emailController: _emailController,
            passwordController: _passwordController,
          ),
          AppVerticalSpace.xmd,
          Align(
            alignment: Alignment.centerRight,
            child: PasswordToggleWidget(
              showPassword: _showPassword,
              onToggle: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            ),
          ),
          AppVerticalSpace.xlg,
          AppButton(text: context.loc.register, onPressed: _handleRegister),
          AppVerticalSpace.sm,
          AppButton(text: context.loc.login, onPressed: context.pop, isAlternative: true),
        ],
      ),
    );
  }

  Future<void> _handleRegister() async {
    try {
      final user = AuthModel(
        email: _emailController.text,
        contrasena: _passwordController.text,
        nombreCompleto: _fullNameController.text,
      );

      await widget.onRegister(user);
    } catch (e) {
      if (mounted) {
        context.showErrorToast(e.toString());
      }
    }
  }
}

class AnimatedHeaderWidget extends StatelessWidget {
  const AnimatedHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: context.svgIconSemantic.user(color: context.color.text),
        ),
        AppVerticalSpace.sm,
        Text(
          context.loc.createAccount,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: context.color.text),
        ),
        AppVerticalSpace.xs,
        Text(
          context.loc.completeInformation,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: context.color.textSecondary),
        ),
      ],
    );
  }
}

class InputFieldsWidget extends StatelessWidget {
  const InputFieldsWidget({
    super.key,
    required this.showPassword,
    required this.fullNameController,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool showPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          hintText: context.loc.fullName,
          textEditingController: fullNameController,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.sm,
              top: AppSpacing.sm,
              bottom: AppSpacing.sm,
            ),
            child: context.svgIconSemantic.user(color: context.color.textSecondary),
          ),
          validator: (value) => _validateNotEmpty(value, context),
          keyboardType: TextInputType.name,
        ),
        AppVerticalSpace.xmd,
        AppTextField(
          hintText: context.loc.email,
          textEditingController: emailController,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.sm,
              top: AppSpacing.sm,
              bottom: AppSpacing.sm,
            ),
            child: context.svgIconSemantic.email(color: context.color.textSecondary),
          ),
          validator: (value) => _validateEmail(value, context),
          keyboardType: TextInputType.emailAddress,
        ),
        AppVerticalSpace.xmd,
        AppTextField(
          hintText: context.loc.password,
          textEditingController: passwordController,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.sm,
              top: AppSpacing.sm,
              bottom: AppSpacing.sm,
            ),
            child: context.svgIconSemantic.lock(color: context.color.textSecondary),
          ),
          validator: (value) => _validatePassword(value, context),
          keyboardType: TextInputType.visiblePassword,
          obscureText: !showPassword,
        ),
      ],
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

  String? _validatePassword(String? value, BuildContext context) {
    if (value == null || value.isEmpty) return context.loc.validateEmpty;
    if (value.length < 8) return 'La contraseña debe tener al menos 8 caracteres';
    if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
      return 'La contraseña debe contener al menos una mayúscula';
    }
    if (!RegExp(r'^(?=.*[a-z])').hasMatch(value)) {
      return 'La contraseña debe contener al menos una minúscula';
    }
    if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
      return 'La contraseña debe contener al menos un número';
    }
    return null;
  }
}

class PasswordToggleWidget extends StatelessWidget {
  const PasswordToggleWidget({super.key, required this.showPassword, required this.onToggle});

  final bool showPassword;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          color: context.color.buttonPrimary.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              showPassword ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
              color: context.color.buttonPrimary,
              size: 16,
            ),
            AppHorizontalSpace.sm,
            Text(
              showPassword ? context.loc.hidePassword : context.loc.showPassword,
              style: TextStyle(
                color: context.color.buttonPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
