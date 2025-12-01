import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/extension/extension.dart';
import 'package:goncook/common/widget/app_botton_sheet.dart';
import 'package:goncook/common/widget/app_confirm_dialog.dart';
import 'package:goncook/common/widget/app_text_form_field.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/features/auth/presentation/bloc/login_bloc.dart';
import 'package:goncook/features/auth/presentation/widget/login/login.dart';
import 'package:goncook/features/auth/presentation/widget/logo_widget.dart';

/// Login form widget that manages state through BLoC.
///
/// This StatefulWidget uses BLoC to manage all form state.
/// TextEditingControllers are provided by parent widget.
/// StatefulWidget is needed to maintain FormState key for validation.
class AnimatedLoginForm extends StatefulWidget {
  const AnimatedLoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<AnimatedLoginForm> createState() => _AnimatedLoginFormState();
}

class _AnimatedLoginFormState extends State<AnimatedLoginForm> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) {
        final emailChanged = previous.email != current.email;
        final passwordChanged = previous.password != current.password;
        final emailErrorChanged = previous.emailError != current.emailError;
        final passwordErrorChanged = previous.passwordError != current.passwordError;
        final errorMessageChanged = previous.errorMessage != current.errorMessage;

        final dialogRequested =
            !previous.shouldShowRecoverPasswordDialog && current.shouldShowRecoverPasswordDialog;

        return emailChanged ||
            passwordChanged ||
            emailErrorChanged ||
            passwordErrorChanged ||
            errorMessageChanged ||
            dialogRequested;
      },
      listener: (context, state) {
        if (state.emailError?.isNotEmpty ?? false) {
          final selection = widget.emailController.selection;
          widget.emailController.value = TextEditingValue(
            text: state.email,
            selection: selection.isValid
                ? selection
                : TextSelection.collapsed(offset: state.email.length),
          );
        }

        if (state.passwordError?.isNotEmpty ?? false) {
          final selection = widget.passwordController.selection;
          widget.passwordController.value = TextEditingValue(
            text: state.password,
            selection: selection.isValid
                ? selection
                : TextSelection.collapsed(offset: state.password.length),
          );
        }
        if (state.errorMessage?.isNotEmpty ?? false) {
          context.showBottomSheet(title: 'Error', child: Text(state.errorMessage!));
        }
        if (state.shouldShowRecoverPasswordDialog) {
          _showRecoverPasswordDialog(context: context);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          final isLoading = state is LoginLoading;
          final formState = state is LoginFormState ? state : const LoginFormState();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LogoWidget(),
              AppVerticalSpace.xmd,
              const HeaderAndSubTitle(),
              AppVerticalSpace.xmd,
              AppTextFormField.email(
                controller: widget.emailController,
                errorText: formState.hasAttemptedValidation ? formState.emailError : null,
              ),
              AppVerticalSpace.xs,
              AppTextFormField.password(
                controller: widget.passwordController,
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
                          email: widget.emailController.text,
                          password: widget.passwordController.text,
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

  /// Shows the recover password dialog.
  ///
  /// This method is called when the BLoC emits RecoverPasswordDialogRequested state.
  /// All business logic is handled by the BLoC.
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
