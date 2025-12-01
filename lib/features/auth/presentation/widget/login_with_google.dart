import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/common/constants/option.dart';
import 'package:goncook/common/widget/app_image.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/features/auth/presentation/bloc/login_bloc.dart';

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final formState = state is LoginFormState ? state : const LoginFormState();

        return AppButton.google(
          iconAtStart: true,
          isGoogle: true,
          text: 'Google',
          onPressed: () {
            context.read<LoginBloc>().add(
              LoginRequested(
                email: formState.email,
                password: formState.password,
                type: LoginWith.withGoogle,
              ),
            );
          },
          showIcon: true,
          iconWidget: context.imageIcon(AppImages.google, size: 20),
          // Image.asset('assets/img/google.png', width: 20, height: 20),
        );
      },
    );
  }
}
