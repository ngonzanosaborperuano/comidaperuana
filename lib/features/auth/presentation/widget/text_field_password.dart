import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/common/config/style/app_styles.dart';
import 'package:goncook/common/extension/extension.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/features/auth/presentation/bloc/login_bloc.dart';

/// Password input field widget that manages state through BLoC.
///
/// Uses a minimal StatefulWidget wrapper only to maintain TextEditingController
/// stability. All business logic is handled by BLoC.
class TextFieldPassword extends StatefulWidget {
  const TextFieldPassword({super.key});

  @override
  State<TextFieldPassword> createState() => _TextFieldPasswordState();
}

class _TextFieldPasswordState extends State<TextFieldPassword> {
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) {
        if (current is! LoginFormState) return false;
        if (previous is! LoginFormState) return true;
        return previous.password != current.password &&
            _passwordController.text != current.password;
      },
      listener: (context, state) {
        final formState = state as LoginFormState;
        if (_passwordController.text != formState.password) {
          final selection = _passwordController.selection;
          _passwordController.value = TextEditingValue(
            text: formState.password,
            selection: selection.isValid
                ? selection
                : TextSelection.collapsed(offset: formState.password.length),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) {
          if (current is! LoginFormState) return false;
          if (previous is! LoginFormState) return true;
          return previous.passwordError != current.passwordError ||
              previous.isPasswordVisible != current.isPasswordVisible;
        },
        builder: (context, state) {
          final formState = state is LoginFormState ? state : const LoginFormState();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                hintText: context.loc.enterPassword,
                textEditingController: _passwordController,
                obscureText: formState.isPasswordVisible,
                obscuringCharacter: '*',
                prefixIcon: Icon(Icons.lock, color: context.color.textSecondary),
                validator: (value) => formState.passwordError,
                onChanged: (value) {
                  context.read<LoginBloc>().add(PasswordChanged(value));
                },
              ),
              TextButton(
                onPressed: () {
                  context.read<LoginBloc>().add(const PasswordVisibilityToggled());
                },
                child: Text(
                  formState.isPasswordVisible ? context.loc.hidePassword : context.loc.showPassword,
                  style: AppStyles.bodyTextBold.copyWith(color: context.color.secondary),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
