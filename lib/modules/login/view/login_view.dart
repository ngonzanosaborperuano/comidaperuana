import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/constants/option.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart';
import 'package:recetasperuanas/modules/login/widget/text_field_password.dart';
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
  late final LoginController con;

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
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.color.background,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: context.color.text.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: SizedBox(
              width: size.width * 0.9,
              height: size.height * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppVerticalSpace.xmd,
                    const Hero(tag: 'logo', child: LogoWidget()),
                    AppVerticalSpace.md,
                    // Botón de prueba de suscripciones
                    /*Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton.icon(
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => const SubscriptionPlansPage(
                                      userEmail: 'demo@ejemplo.com',
                                      userName: 'Usuario Demo',
                                    ),
                              ),
                            ),
                        icon: const Icon(Icons.star, color: Colors.white),
                        label: const Text(
                          '🚀 Probar Suscripciones PayU',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          elevation: 5,
                        ),
                      ),
                    ),
                          */
                    AppVerticalSpace.sm,
                    AppText(
                      text: context.loc.login,
                      fontSize: AppSpacing.xxmd,
                      fontWeight: FontWeight.bold,
                      color: context.color.text,
                    ),
                    AppVerticalSpace.md,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AppText(
                        text: context.loc.descriptionLogin,
                        fontSize: AppSpacing.md,
                        fontWeight: FontWeight.w400,
                        color: context.color.text,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    AppVerticalSpace.xmd,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Form(
                        key: _formKeyLogin,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            AppTextField(
                              hintText: context.loc.enterEmail,
                              textEditingController: con.emailController,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icon(Icons.email, color: context.color.textSecondary),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9@.]')),
                              ],
                              validator: (value) => con.validateEmail(value ?? '', context),
                            ),
                            AppVerticalSpace.md,
                            TextFieldPassword(con: con),
                            SizedBox(
                              width: double.infinity,
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 10),
                                  TextButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        showDragHandle: true,
                                        isScrollControlled: true,
                                        backgroundColor: context.color.backgroundCard,
                                        builder: (context) {
                                          TextEditingController textEditingController =
                                              TextEditingController();
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 15,
                                              bottom: MediaQuery.of(context).viewInsets.bottom + 15,
                                            ),
                                            child: SingleChildScrollView(
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: MediaQuery.sizeOf(context).height * 0.4,
                                                child: Column(
                                                  children: [
                                                    AppText(
                                                      text: context.loc.recoverPassword,
                                                      fontWeight: FontWeight.bold,
                                                      color: context.color.text,
                                                    ),
                                                    AppVerticalSpace.md,
                                                    AppText(
                                                      text: context.loc.recoverAccountMessage,
                                                      color: context.color.text,
                                                      fontSize: AppSpacing.md,
                                                    ),
                                                    AppVerticalSpace.lg,
                                                    AppTextField(
                                                      hintText: context.loc.email,
                                                      textEditingController: textEditingController,
                                                      prefixIcon: Icon(
                                                        Icons.email,
                                                        color: context.color.textSecondary,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    _buttonRecoveriPass(
                                                      context,
                                                      textEditingController,
                                                    ),
                                                    AppVerticalSpace.xxmd,
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: AppText(
                                      text: context.loc.recoverEmail,
                                      fontSize: AppSpacing.md,
                                      color: context.color.textSecondary2,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            AppButton(
                              text: context.loc.login,
                              onPressed: () async {
                                if (!_formKeyLogin.currentState!.validate()) return;
                                await const LoadingDialog().show(
                                  context,
                                  future: () async {
                                    var mensageUser = '';
                                    final (isSuccess, msg) = await con.login(
                                      user: AuthUser(
                                        email: con.emailController.text,
                                        contrasena: con.passwordController.text,
                                      ),
                                      type: LoginWith.withUserPassword,
                                    );

                                    if (isSuccess) {
                                      if (!context.mounted) {
                                        return (false, 'Context is not mounted.');
                                      }
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
                                      } else if (msg ==
                                          'account-exists-with-different-credential') {
                                        mensageUser =
                                            context.loc.accountExistsWithDifferentCredential;
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
                              showIcon: false,
                            ),
                            AppVerticalSpace.md,
                            const DividerWidget(),
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
                                    color: context.color.textSecondary2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //LoginUserPass(formKeyLogin: _formKeyLogin, con: con),
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

  AppButton _buttonRecoveriPass(BuildContext context, TextEditingController textEditingController) {
    return AppButton(
      text: context.loc.send,
      onPressed: () async {
        await const LoadingDialog().show(
          context,
          future: () async {
            final msg = await con.recoverCredential(textEditingController.text);
            if (!context.mounted) return;
            switch (msg) {
              case 'success':
                context.showSuccessToast(
                  context.loc.recoverPassword,
                  title: context.loc.recoverPassword,
                );

                break;
              case 'invalid-email':
                context.showErrorToast(
                  context.loc.errorInvalidEmail,
                  title: context.loc.errorInvalidEmail,
                );
                break;
              case 'user-not-found':
                context.showErrorToast(
                  context.loc.errorInvalidEmail,
                  title: context.loc.errorInvalidEmail,
                );
                break;
              case 'too-many-requests':
                context.showErrorToast(
                  context.loc.errorTooManyRequests,
                  title: context.loc.errorTooManyRequests,
                );
                break;
              case 'network-request-failed':
                context.showErrorToast(context.loc.errorNetwork, title: context.loc.errorNetwork);
                break;
              default:
                context.showErrorToast(context.loc.errorDefault, title: context.loc.errorDefault);
                break;
            }
          },
        );
      },
    );
  }
}
