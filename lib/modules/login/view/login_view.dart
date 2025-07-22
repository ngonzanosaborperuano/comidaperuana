import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/constants/option.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart';
import 'package:recetasperuanas/modules/login/widget/widget.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/animated_widgets.dart';
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
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double maxWidth = constraints.maxWidth > 600 ? 450 : double.infinity;
                  return FormRegister(
                    maxWidth: maxWidth,
                    formKeyLogin: _formKeyLogin,
                    formAnimation: formAnimation,
                    con: con,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class FormRegister extends StatelessWidget {
  const FormRegister({
    super.key,
    required this.maxWidth,
    required GlobalKey<FormState> formKeyLogin,
    required this.formAnimation,
    required this.con,
  }) : _formKeyLogin = formKeyLogin;

  final double maxWidth;
  final GlobalKey<FormState> _formKeyLogin;
  final Animation<double> formAnimation;
  final LoginController con;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: context.color.background,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: context.color.textSecondary.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      "O continuar con",
                      style: TextStyle(color: context.color.textSecondary),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              AppVerticalSpace.md,
              LoginWithGoogle(con: con),
              AppVerticalSpace.lg,
              Row(
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
            ],
          ),
        ),
      ),
    );
  }
}
