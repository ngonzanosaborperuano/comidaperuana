import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/widget/app_confirm_dialog.dart';
import 'package:goncook/common/widget/app_text_form_field.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/core/constants/option.dart';
import 'package:goncook/core/extension/extension.dart';
import 'package:goncook/features/auth/presentation/bloc/login_bloc.dart';
import 'package:goncook/features/auth/presentation/widget/login/login.dart';

class AnimatedLoginForm extends StatelessWidget {
  const AnimatedLoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: _shouldListenToFormChanges,
      listener: _handleFormStateChanges,
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          final isLoading = state is LoginProcessState ? state.isLoading : false;
          final formState = state is LoginFormState ? state : const LoginFormState();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LogoWidget(),
              AppVerticalSpace.xmd,
              const HeaderAndSubTitle(),
              AppVerticalSpace.xmd,
              AppTextFormField.email(
                controller: emailController,
                errorText: formState.hasAttemptedValidation ? formState.emailError : null,
              ),
              AppVerticalSpace.xs,
              AppTextFormField.password(
                controller: passwordController,
                showCounterAsSuffix: false,
                maxLength: 50,
                errorText: formState.hasAttemptedValidation ? formState.passwordError : null,
              ),
              AppVerticalSpace.xmd,
              LoginButton(
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () => context.read<LoginBloc>().add(
                        LoginButtonPressed(
                          email: emailController.text,
                          password: passwordController.text,
                        ),
                      ),
                context: context,
              ),
              RecoverPassword(
                onTap: () => context.read<LoginBloc>().add(const RecoverPasswordButtonPressed()),
                context: context,
              ),
            ],
          );
        },
      ),
    );
  }

  bool formIsValid(LoginState previous, LoginState current) {
    final previousIsValid = previous is LoginFormState ? previous.isValid : false;
    final currentIsValid = current is LoginFormState ? current.isValid : false;
    final previousEmailError = previous is LoginFormState ? previous.emailError : null;
    final currentEmailError = current is LoginFormState ? current.emailError : null;
    final previousPasswordError = previous is LoginFormState ? previous.passwordError : null;
    final currentPasswordError = current is LoginFormState ? current.passwordError : null;

    return previousIsValid != currentIsValid ||
        previousEmailError != currentEmailError ||
        previousPasswordError != currentPasswordError;
  }

  bool _shouldListenToFormChanges(LoginState previous, LoginState current) {
    return formIsValid(previous, current);
  }

  void _handleFormStateChanges(BuildContext context, LoginState state) {
    if (state is LoginFormState && state.isValid) {
      _triggerLoginRequest(context, state);
    }

    if (state is RecoverCredentialSuccess) {
      _showRecoverPasswordDialog(context: context);
    }
  }

  void _triggerLoginRequest(BuildContext context, LoginFormState formState) {
    context.read<LoginBloc>().add(
      LoginRequested(
        email: formState.email,
        password: formState.password,
        type: LoginWith.withUserPassword,
      ),
    );
  }

  Future<void> _showRecoverPasswordDialog({required BuildContext context}) {
    final textEditingController = TextEditingController();
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AppConfirmDialog(
        title: context.loc.recoverPassword,
        content: Column(
          children: [
            AppText(
              text: context.loc.recoverAccountMessage,
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: context.color.textSecondary,
              textAlign: TextAlign.center,
            ),
            AppVerticalSpace.md,
            AppTextField(hintText: context.loc.email, textEditingController: textEditingController),
          ],
        ),
        confirmLabel: context.loc.send,
        cancelLabel: context.loc.cancel,
        onConfirm: () async {
          await const LoadingDialog().show(
            context,
            future: () async {
              context.read<LoginBloc>().add(RecoverCredentialRequested(textEditingController.text));
            },
          );
          if (!context.mounted) return;
          context.pop();
        },
        onCancel: context.pop,
        confirmColor: context.color.buttonPrimary,
        borderColorFrom: context.color.buttonPrimary,
        borderColorTo: context.color.error,
      ),
    );
  }
}
