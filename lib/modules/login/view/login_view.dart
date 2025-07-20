import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/constants/option.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart';
import 'package:recetasperuanas/modules/login/widget/widget.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with TickerProviderStateMixin, StaggeredAnimationMixin {
  late final GlobalKey<FormState> _formKeyLogin;
  late LoginController con;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();

    // Inicializar animaciones
    initializeAnimations();

    // Iniciar animaciones escalonadas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startStaggeredAnimations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (_, LoginController con, _) {
        this.con = con;
        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppVerticalSpace.xmd,

                  // Logo animado
                  RepaintBoundary(
                    child: AnimatedScaleWidget(
                      animation: scaleAnimation,
                      child: const AnimatedLogoWidget(
                        child: Hero(tag: 'logo', child: LogoWidget()),
                      ),
                    ),
                  ),

                  AppVerticalSpace.md,

                  // Título con animación de entrada
                  RepaintBoundary(
                    child: AnimatedEntryWidget(
                      animation: fadeAnimation,
                      slideOffset: const Offset(0, 0.2),
                      child: AppText(
                        text: context.loc.login,
                        fontSize: AppSpacing.xxmd,
                        fontWeight: FontWeight.bold,
                        color: context.color.text,
                      ),
                    ),
                  ),

                  AppVerticalSpace.md,

                  // Descripción con animación fade
                  RepaintBoundary(
                    child: FadeTransition(
                      opacity: fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AppText(
                          text: context.loc.descriptionLogin,
                          fontSize: AppSpacing.md,
                          fontWeight: FontWeight.w400,
                          color: context.color.text,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  AppVerticalSpace.xmd,

                  // Formulario animado
                  AnimatedLoginForm(
                    formKey: _formKeyLogin,
                    controller: con,
                    animation: formAnimation,
                    onLogin: (user) async {
                      await const LoadingDialog().show(
                        context,
                        future: () async {
                          var mensageUser = '';
                          final (isSuccess, msg) = await con.login(
                            user: user,
                            type: LoginWith.withUserPassword,
                          );

                          if (isSuccess) {
                            if (!context.mounted) {
                              return (false, 'Context is not mounted.');
                            }
                            context.showSuccessToast(context.loc.welcomeToCocinandoIA);
                            context.go(Routes.home.description);
                          } else {
                            if (!context.mounted) {
                              return (false, 'Context is not mounted.');
                            }

                            if (msg == 'weak-password') {
                              mensageUser = context.loc.weakPassword;
                            } else if (msg == 'email-already-in-use') {
                              mensageUser = context.loc.emailAlreadyInUse;
                            } else if (msg == 'user-not-found') {
                              mensageUser = context.loc.userNotFound;
                            } else if (msg == 'wrong-password') {
                              mensageUser = context.loc.wrongPassword;
                            } else if (msg == 'user-disabled') {
                              mensageUser = context.loc.userDisabled;
                            } else if (msg == 'operation-not-allowed') {
                              mensageUser = context.loc.operationNotAllowed;
                            } else if (msg == 'account-exists-with-different-credential') {
                              mensageUser = context.loc.accountExistsWithDifferentCredential;
                            } else if (msg == 'invalid-credential') {
                              mensageUser = context.loc.invalidCredential;
                            } else {
                              mensageUser = context.loc.authError;
                            }

                            await showAdaptiveDialog(
                              context: context,
                              builder: (context) {
                                return AppModalAlert(
                                  text: mensageUser,
                                  title: context.loc.titleAccessDenied,
                                  maxHeight: 200,
                                  icon: Icons.error,
                                  labelButton: context.loc.accept,
                                  onPressed: context.pop,
                                );
                              },
                            );
                          }
                        },
                      );
                    },
                  ),

                  AppVerticalSpace.xlg,

                  // Divider con animación fade
                  RepaintBoundary(
                    child: FadeTransition(opacity: fadeAnimation, child: const DividerWidget()),
                  ),

                  AppVerticalSpace.md,

                  // Login con Google con animación de entrada
                  RepaintBoundary(
                    child: AnimatedEntryWidget(
                      animation: fadeAnimation,
                      slideOffset: const Offset(0, 0.1),
                      child: LoginWithGoogle(con: con),
                    ),
                  ),

                  AppVerticalSpace.lg,

                  // Enlace de registro con animación fade
                  RepaintBoundary(
                    child: FadeTransition(
                      opacity: fadeAnimation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(
                            text: context.loc.dontHaveAccount,
                            fontSize: AppSpacing.md,
                            fontWeight: FontWeight.w400,
                            color: context.color.text,
                          ),
                          TextButton(
                            onPressed: () {
                              context.go(Routes.register.description);
                            },
                            child: AppText(
                              text: context.loc.register,
                              fontSize: AppSpacing.md,
                              fontWeight: FontWeight.w400,
                              color: context.color.buttonPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  AppVerticalSpace.xlg,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
