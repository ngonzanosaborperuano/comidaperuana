import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/extension/extension.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/core/router/routes.dart' show Routes;
import 'package:goncook/features/auth/presentation/bloc/login_bloc.dart';
import 'package:goncook/features/auth/presentation/widget/widget.dart'
    show AnimatedLoginForm, LoginWithGoogle;

/// Login screen widget that manages authentication flow using BLoC pattern.
///
/// This widget is a StatelessWidget that manages all state through BLoC.
/// Animations are handled using implicit Flutter animations that don't require StatefulWidget.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.showSuccessToast('Bienvenido a CocinandoIA');
          context.go(Routes.home.description);
        } else if (state is LoginError) {
          context.showErrorToast(state.message);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.color.buttonPrimary.withAlpha(100),
                  context.color.error.withAlpha(100),
                  context.color.error.withAlpha(100),
                  context.color.buttonPrimary.withAlpha(100),
                ],
              ),
            ),
            child: const Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: _LoginContent(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) {
        if (current is! LoginFormState) return false;
        if (previous is LoginFormState) {
          final prevFormState = previous;
          final currFormState = current;
          return prevFormState.email != currFormState.email ||
              prevFormState.password != currFormState.password;
        }
        //si son vacios, no se sincroniza
        if (emailController.text.isEmpty && passwordController.text.isEmpty) {
          return false;
        }
        return true;
      },
      listener: (context, state) {
        if (state is! LoginFormState) return;
        final formState = state;
        // Sincronizar email controller
        if (emailController.text != formState.email) {
          final selection = emailController.selection;
          emailController.value = TextEditingValue(
            text: formState.email,
            selection: selection.isValid
                ? selection
                : TextSelection.collapsed(offset: formState.email.length),
          );
        }
        // Sincronizar password controller
        if (passwordController.text != formState.password) {
          final selection = passwordController.selection;
          passwordController.value = TextEditingValue(
            text: formState.password,
            selection: selection.isValid
                ? selection
                : TextSelection.collapsed(offset: formState.password.length),
          );
        }
      },
      child: Card(
        elevation: 2,
        color: context.color.background,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: context.color.border.withAlpha(100),
            style: BorderStyle.solid,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            spacing: AppSpacing.md,
            children: [
              AnimatedLoginForm(
                emailController: emailController,
                passwordController: passwordController,
              ),
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                  AppText(text: ' O ', fontSize: 14),
                  Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                ],
              ),
              const LoginWithGoogle(),
              Row(
                children: [
                  const AppText(text: '¿No tienes cuenta?', fontSize: AppSpacing.md),
                  TextButton(
                    child: const AppText(text: 'Registrarse', fontSize: AppSpacing.md),
                    onPressed: () => context.push(Routes.register.description),
                  ),
                  AppVerticalSpace.md,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
