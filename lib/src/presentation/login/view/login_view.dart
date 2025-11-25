import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/src/application/use_cases/login_use_case.dart';
import 'package:goncook/src/application/use_cases/logout_use_case.dart';
import 'package:goncook/src/application/use_cases/register_use_case.dart';
import 'package:goncook/src/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:goncook/src/domain/auth/repositories/i_user_repository.dart';
import 'package:goncook/src/presentation/login/bloc/login_bloc.dart';
import 'package:goncook/src/presentation/login/bloc/login_event.dart' show LoginRequested;
import 'package:goncook/src/presentation/login/controller/login_controller.dart';
import 'package:goncook/src/presentation/login/widget/widget.dart'
    show AnimatedLoginForm, LoginWithGoogle;
import 'package:goncook/src/shared/constants/option.dart' show LoginWith;
import 'package:goncook/src/shared/constants/routes.dart' show Routes;
import 'package:goncook/src/shared/controller/base_controller.dart';
import 'package:goncook/src/shared/widget/animated_widgets.dart';
import 'package:goncook/src/shared/widget/responsive_constrained_box.dart';
import 'package:goncook/src/shared/widget/widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with TickerProviderStateMixin, StaggeredAnimationMixin {
  late final GlobalKey<FormState> _formKeyLogin;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    initializeAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startStaggeredAnimations();
    });
  }

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
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: ResponsiveConstrainedBox(
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
                              formKey: _formKeyLogin,
                              animation: formAnimation,
                              controller: LoginController(
                                loginUseCase: LoginUseCase(context.read<IUserAuthRepository>()),
                                registerUseCase: RegisterUseCase(
                                  context.read<IUserAuthRepository>(),
                                ),
                                logoutUseCase: LogoutUseCase(context.read<IUserAuthRepository>()),
                                userRepository: context.read<IUserRepository>(),
                              ),
                              onLogin: (user) async {
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
                                registerUseCase: RegisterUseCase(
                                  context.read<IUserAuthRepository>(),
                                ),
                                logoutUseCase: LogoutUseCase(context.read<IUserAuthRepository>()),
                                userRepository: context.read<IUserRepository>(),
                              ),
                            ),
                            Row(
                              children: [
                                const AppText(text: '¿No tienes cuenta?', fontSize: AppSpacing.md),
                                TextButton(
                                  child: const AppText(
                                    text: 'Registrarse',
                                    fontSize: AppSpacing.md,
                                  ),
                                  onPressed: () => context.push(Routes.register.description),
                                ),
                                AppVerticalSpace.md,
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
