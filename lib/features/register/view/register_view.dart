import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/widget/app_text_form_field.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/core/extension/extension.dart';
import 'package:goncook/core/router/routes.dart';
import 'package:goncook/features/auth/data/models/auth_model.dart';
import 'package:goncook/features/register/bloc/register_bloc.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final fullNameController = TextEditingController();
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) async {
        if (state is RegisterSuccess) {
          if (!context.mounted) return;
          context.go(Routes.home.description);
        } else if (state is RegisterError) {
          if (!context.mounted) return;
          await showAdaptiveDialog(
            context: context,
            builder: (context) {
              return AppModalAlert(
                text: state.message,
                title: 'Error de Registro',
                maxHeight: 200,
                icon: Icons.error,
                labelButton: 'Aceptar',
                onPressed: context.pop,
              );
            },
          );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 2 * kTextTabBarHeight),
                    const LogoWidget(),
                    AppVerticalSpace.xmd,
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          context.loc.createAccount,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),

                        AppVerticalSpace.xmd,
                        Text(
                          context.loc.completeInformation,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        AppVerticalSpace.xmd,
                        AppTextFormField(
                          controller: fullNameController,
                          hintText: context.loc.fullName,
                          autocorrect: false,
                        ),
                        AppTextFormField.email(
                          controller: emailController,
                          hintText: context.loc.email,
                        ),
                        AppTextFormField.password(
                          maxLength: 50,
                          showCounterAsSuffix: false,
                          controller: passwordController,
                          hintText: context.loc.password,
                        ),
                      ],
                    ),
                  ),
                ),
                AppVerticalSpace.xmd,
                AppButton(
                  text: context.loc.register,
                  onPressed: () => _handleRegister(
                    context,
                    AuthModel(
                      email: emailController.text,
                      contrasena: passwordController.text,
                      nombreCompleto: fullNameController.text,
                    ),
                  ),
                ),
                AppVerticalSpace.xmd,
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleRegister(BuildContext context, AuthModel user) async {
    await const LoadingDialog().show(
      context,
      future: () async {
        context.read<RegisterBloc>().add(
          RegisterRequested(
            email: user.email,
            password: user.contrasena ?? '',
            fullName: user.nombreCompleto,
          ),
        );
      },
    );
  }
}
