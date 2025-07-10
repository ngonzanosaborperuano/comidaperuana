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
    final size = MediaQuery.sizeOf(context);
    return Consumer<LoginController>(
      builder: (_, LoginController con, _) {
        return Center(
          child: SizedBox(
            width: size.width * 0.9,
            height: size.height * 0.8,
            child: Card(
              color: context.color.backgroundCard,
              elevation: 10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppVerticalSpace.xlg,
                    const LogoWidget(),
                    AppVerticalSpace.sm,
                    AppText(
                      text: context.loc.login,
                      fontSize: AppSpacing.xxmd,
                      fontWeight: FontWeight.bold,
                      color: context.color.text,
                    ),
                    AppVerticalSpace.md,
                    AppText(
                      text: context.loc.descriptionLogin,
                      fontSize: AppSpacing.md,
                      fontWeight: FontWeight.w400,
                      color: context.color.text,
                      textAlign: TextAlign.center,
                    ),
                    AppVerticalSpace.xmd,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          AppTextField(
                            hintText: context.loc.email,
                            textEditingController: con.emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(Icons.email),
                          ),
                          AppVerticalSpace.md,
                          AppTextField(
                            hintText: context.loc.password,
                            textEditingController: con.passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            prefixIcon: const Icon(Icons.lock),
                          ),
                          AppVerticalSpace.md,
                          SizedBox(
                            width: size.width,
                            child: AppText(
                              text: context.loc.recoverEmail,
                              fontSize: AppSpacing.md,
                              fontWeight: FontWeight.w400,
                              color: context.color.textSecondary2,
                              textAlign: TextAlign.right,
                            ),
                          ),
                          AppVerticalSpace.md,
                          AppButton(text: context.loc.login, onPressed: () {}),

                          AppVerticalSpace.md,
                          const DividerWidget(),
                          AppVerticalSpace.md,
                          LoginWithGoogle(con: con),
                        ],
                      ),
                    ),

                    AppVerticalSpace.xlg,
                    LoginUserPass(formKeyLogin: _formKeyLogin, con: con),

                    AppVerticalSpace.xlg,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
