import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/constants/option.dart' show LoginWith;
import 'package:goncook/common/constants/routes.dart' show Routes;
import 'package:goncook/common/controller/base_controller.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/features/auth/controller/login_controller.dart';
import 'package:goncook/features/auth/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:goncook/features/auth/domain/auth/repositories/i_user_repository.dart';
import 'package:goncook/features/auth/domain/usecases/auth_usecase.dart';
import 'package:goncook/features/auth/domain/usecases/logout_usecase.dart';
import 'package:goncook/features/auth/domain/usecases/register_usecase.dart';
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

/// Content widget for login form.
///
/// This StatelessWidget manages all state through BLoC, eliminating
/// the need for StatefulWidget. The form key is created per build cycle.
class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    final formKeyLogin = GlobalKey<FormState>();

    return Card(
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
              formKey: formKeyLogin,
              animation: const AlwaysStoppedAnimation(1.0),
              controller: LoginController(
                loginUseCase: LoginUseCase(context.read<IUserAuthRepository>()),
                registerUseCase: RegisterUseCase(context.read<IUserAuthRepository>()),
                logoutUseCase: LogoutUseCase(context.read<IUserAuthRepository>()),
                userRepository: context.read<IUserRepository>(),
              ),
              onLogin: (user) {
                context.read<LoginBloc>().add(
                  LoginRequested(
                    email: user.email,
                    password: user.contrasena ?? '',
                    type: LoginWith.withUserPassword,
                  ),
                );
              },
            ),
            const Row(
              children: [
                Expanded(child: Divider(color: Colors.grey, thickness: 1)),
                AppText(text: ' O ', fontSize: 14),
                Expanded(child: Divider(color: Colors.grey, thickness: 1)),
              ],
            ),
            LoginWithGoogle(
              con: LoginController(
                loginUseCase: LoginUseCase(context.read<IUserAuthRepository>()),
                registerUseCase: RegisterUseCase(context.read<IUserAuthRepository>()),
                logoutUseCase: LogoutUseCase(context.read<IUserAuthRepository>()),
                userRepository: context.read<IUserRepository>(),
              ),
            ),
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
    );
  }
}
