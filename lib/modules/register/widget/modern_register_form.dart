import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/modules/register/controller/register_controller.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

class ModernRegisterForm extends StatefulWidget {
  const ModernRegisterForm({
    super.key,
    required this.formKey,
    required this.controller,
    required this.onRegister,
  });

  final GlobalKey<FormState> formKey;
  final RegisterController controller;
  final Future<void> Function(AuthUser user) onRegister;

  @override
  State<ModernRegisterForm> createState() => _ModernRegisterFormState();
}

class _ModernRegisterFormState extends State<ModernRegisterForm> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late AnimationController _successController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _successController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Form(
          key: widget.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedHeaderWidget(pulseAnimation: _pulseAnimation),
                AppVerticalSpace.xlg,
                InputFieldsWidget(controller: widget.controller, showPassword: _showPassword),
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
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!widget.formKey.currentState!.validate()) return;

    try {
      final user = AuthUser(
        email: widget.controller.emailController.text,
        contrasena: widget.controller.passwordController.text,
        nombreCompleto: widget.controller.fullNameController.text,
      );

      await widget.onRegister(user);
    } catch (e) {
      if (mounted) {
        context.showErrorToast(e.toString());
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    _successController.dispose();
    super.dispose();
  }
}

class AnimatedHeaderWidget extends StatelessWidget {
  const AnimatedHeaderWidget({super.key, required this.pulseAnimation});

  final Animation<double> pulseAnimation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: pulseAnimation.value,
              child: SizedBox(
                width: 50,
                height: 50,
                child: context.svgIconSemantic.user(color: context.color.text),
              ),
            );
          },
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
  const InputFieldsWidget({super.key, required this.controller, required this.showPassword});

  final RegisterController controller;
  final bool showPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          hintText: context.loc.fullName,
          textEditingController: controller.fullNameController,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: context.svgIconSemantic.user(color: context.color.textSecondary),
          ),
          validator: (value) => controller.validateEmpty(value ?? '', context),
          keyboardType: TextInputType.name,
        ),
        AppVerticalSpace.xmd,
        AppTextField(
          hintText: context.loc.email,
          textEditingController: controller.emailController,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: context.svgIconSemantic.email(color: context.color.textSecondary),
          ),
          validator: (value) => controller.validateEmail(value ?? '', context),
          keyboardType: TextInputType.emailAddress,
        ),
        AppVerticalSpace.xmd,
        AppTextField(
          hintText: context.loc.password,
          textEditingController: controller.passwordController,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: context.svgIconSemantic.lock(color: context.color.textSecondary),
          ),
          validator: (value) => controller.validatePassword(value ?? '', context),
          keyboardType: TextInputType.visiblePassword,
          obscureText: !showPassword,
        ),
      ],
    );
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
