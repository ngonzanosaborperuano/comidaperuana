import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/widget/app_botton_sheet.dart';
import 'package:goncook/common/widget/app_text_form_field.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/core/extension/extension.dart';
import 'package:goncook/core/extension/loading.dart';
import 'package:goncook/core/router/routes.dart';
import 'package:goncook/features/auth/data/models/auth_model.dart';
import 'package:goncook/features/auth/presentation/widget/widget.dart';
import 'package:goncook/features/register/bloc/register_bloc.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  void _listener(BuildContext context, RegisterState state) async {
    if (state is RegisterProcessState && state.isLoading) {
      await context.showLoading();
    }

    if (state is RegisterSuccess) {
      if (!context.mounted) return;
      context.go(Routes.home.description);
    } else if (state is RegisterError) {
      if (!context.mounted) return;
      context
        ..hideLoading()
        ..showBottomSheet(
          title: 'Error de Registro',
          onClose: context.pop,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(text: state.message, fontSize: AppSpacing.md),
              AppVerticalSpace.xmd,
              AppButton(text: 'Entendido', onPressed: context.pop),
            ],
          ),
        );
    }
  }

  bool _listenWhenState(RegisterState previous, RegisterState current) {
    final previousIsLoading = previous is RegisterProcessState ? previous.isLoading : false;
    final currentIsLoading = current is RegisterProcessState ? current.isLoading : false;
    final previousIsSuccess = previous is RegisterSuccess ? true : false;
    final currentIsSuccess = current is RegisterSuccess ? true : false;
    final previousIsError = previous is RegisterError ? true : false;
    final currentIsError = current is RegisterError ? true : false;

    return previousIsLoading != currentIsLoading ||
        previousIsSuccess != currentIsSuccess ||
        previousIsError != currentIsError;
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final fullNameController = TextEditingController();
    return BlocListener<RegisterBloc, RegisterState>(
      listenWhen: _listenWhenState,
      listener: _listener,
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.color.background,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: context.color.border.withAlpha(100),
                          style: BorderStyle.solid,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            AppVerticalSpace.xmd,
                            const LogoWidget(),
                            AppVerticalSpace.xlg,
                            Text(
                              context.loc.createAccount,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),

                            AppVerticalSpace.xmd,
                            Text(
                              context.loc.completeInformation,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
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

  void _handleRegister(BuildContext context, AuthModel user) {
    context.read<RegisterBloc>().add(
      RegisterRequested(
        email: user.email,
        password: user.contrasena ?? '',
        fullName: user.nombreCompleto,
      ),
    );
  }
}
