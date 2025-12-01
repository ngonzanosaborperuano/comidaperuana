import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/common/config/config.dart' show AppStyles;
import 'package:goncook/common/extension/extension.dart';
import 'package:goncook/common/widget/animated_widgets.dart' show AnimatedEntryWidget;
import 'package:goncook/common/widget/widget.dart' show AppTextField;
import 'package:goncook/features/auth/presentation/bloc/login_bloc.dart';

/// Password input field widget that manages state through BLoC.
///
/// This StatelessWidget receives TextEditingController from parent widget.
/// All business logic is handled by BLoC.
class PasswordLogin extends StatelessWidget {
  const PasswordLogin({super.key, required this.animation, required this.passwordController});

  final Animation<double> animation;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) {
        if (current is! LoginFormState) return false;
        if (previous is! LoginFormState) return true;
        return previous.passwordError != current.passwordError ||
            previous.isPasswordVisible != current.isPasswordVisible;
      },
      builder: (context, state) {
        final formState = state is LoginFormState ? state : const LoginFormState();

        return RepaintBoundary(
          child: AnimatedEntryWidget(
            animation: animation,
            slideOffset: const Offset(0.3, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  textEditingController: passwordController,
                  hintText: context.loc.password,
                  obscureText: formState.isPasswordVisible,
                  onChanged: (value) {
                    context.read<LoginBloc>().add(PasswordChanged(value));
                  },
                  validator: (value) {
                    // Si ya se intentó validar, mostrar el error del BLoC
                    if (formState.hasAttemptedValidation) {
                      return formState.passwordError;
                    }
                    // Si no se ha intentado validar, no mostrar error
                    return null;
                  },
                ),
                TextButton(
                  onPressed: () {
                    context.read<LoginBloc>().add(const PasswordVisibilityToggled());
                  },
                  child: Text(
                    formState.isPasswordVisible
                        ? context.loc.showPassword
                        : context.loc.hidePassword,
                    style: AppStyles.bodyTextBold.copyWith(color: context.color.text),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
