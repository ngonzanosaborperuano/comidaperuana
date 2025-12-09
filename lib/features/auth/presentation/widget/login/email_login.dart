import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/common/widget/animated_widgets.dart' show AnimatedEntryWidget;
import 'package:goncook/common/widget/widget.dart' show AppTextField;
import 'package:goncook/core/extension/extension.dart';
import 'package:goncook/features/auth/presentation/bloc/login_bloc.dart';

/// Email input field widget that manages state through BLoC.
///
/// This StatelessWidget receives TextEditingController from parent widget.
/// All business logic is handled by BLoC.
class EmailLogin extends StatelessWidget {
  const EmailLogin({super.key, required this.animation, required this.emailController});

  final Animation<double> animation;
  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) {
        if (current is! LoginFormState) return false;
        if (previous is! LoginFormState) return true;
        return previous.emailError != current.emailError;
      },
      builder: (context, state) {
        final formState = state is LoginFormState ? state : const LoginFormState();

        return RepaintBoundary(
          child: AnimatedEntryWidget(
            animation: animation,
            slideOffset: const Offset(-0.3, 0),
            child: AppTextField(
              textEditingController: emailController,
              hintText: context.loc.email,
              keyboardType: TextInputType.emailAddress,
              inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9@.]'))],
              onChanged: (value) {
                context.read<LoginBloc>().add(EmailChanged(value));
              },
              validator: (value) {
                // Solo mostrar error si ya se intentó validar el formulario
                return formState.hasAttemptedValidation ? formState.emailError : null;
              },
            ),
          ),
        );
      },
    );
  }
}
