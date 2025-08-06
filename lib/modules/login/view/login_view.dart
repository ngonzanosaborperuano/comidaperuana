import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/constants/option.dart' show LoginWith;
import 'package:recetasperuanas/core/constants/routes.dart' show Routes;
import 'package:recetasperuanas/modules/login/controller/login_controller_old.dart';
import 'package:recetasperuanas/modules/login/widget/widget.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/animated_widgets.dart';
import 'package:recetasperuanas/shared/widget/responsive_constrained_box.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

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
    return Consumer<LoginControllerOld>(
      builder: (_, LoginControllerOld con, _) {
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ResponsiveConstrainedBox(
                child: Card(
                  elevation: 5,
                  color: context.color.background,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(
                      color: context.color.border.withAlpha(50),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      spacing: AppSpacing.md,
                      children: [
                        AnimatedLoginForm(
                          formKey: _formKeyLogin,
                          controller: con,
                          animation: formAnimation,
                          onLogin: (user) async {
                            final (success, msg) = await con.login(
                              user: user,
                              type: LoginWith.withUserPassword,
                            );
                            if (success) {
                              if (!context.mounted) return;
                              context.showSuccessToast(context.loc.welcomeToCocinandoIA);
                              context.go(Routes.home.description);
                            } else {
                              if (!context.mounted) return;
                              context.showErrorToast(context.loc.authError);
                            }
                          },
                        ),
                        Row(
                          children: [
                            Expanded(child: Divider(color: context.color.border, thickness: 1)),
                            AppText(text: ' ${context.loc.or} '),
                            Expanded(child: Divider(color: context.color.border, thickness: 1)),
                          ],
                        ),
                        LoginWithGoogle(con: con),
                        Row(
                          children: [
                            AppText(text: context.loc.dontHaveAccount, fontSize: AppSpacing.md),
                            TextButton(
                              child: AppText(text: context.loc.register, fontSize: AppSpacing.md),
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
        );
      },
    );
  }
}
