import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart';
import 'package:recetasperuanas/modules/login/widget/widget.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/spacing/spacing.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final GlobalKey<FormState> _formKeyLogin;

  @override
  void initState() {
    _formKeyLogin = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (_, LoginController con, __) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppVerticalSpace.xlg,
                const LogoWidget(),
                AppVerticalSpace.xxmd,
                AppText(
                  text: context.loc.login,
                  fontSize: AppSpacing.xmd,
                  fontWeight: FontWeight.bold,
                ),
                AppVerticalSpace.md,
                LoginWithGoogle(con: con),
                AppVerticalSpace.md,
                const DividerWidget(),
                AppText(
                  text: context.loc.descriptionLogin,
                  fontSize: AppSpacing.md,
                  fontWeight: FontWeight.w400,
                ),
                AppVerticalSpace.md,
                AppVerticalSpace.xlg,
                LoginUserPass(formKeyLogin: _formKeyLogin, con: con),

                AppVerticalSpace.xlg,
              ],
            ),
          ),
        );
      },
    );
  }
}
