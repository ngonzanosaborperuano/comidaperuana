import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/config/color/app_colors.dart' show AppColors;
import 'package:goncook/common/config/config.dart' show AppStyles;
import 'package:goncook/common/constants/option.dart';
import 'package:goncook/common/extension/extension.dart';
import 'package:goncook/common/utils/util.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/core/router/routes.dart';
import 'package:goncook/features/auth/presentation/bloc/login_bloc.dart';
import 'package:goncook/features/auth/presentation/widget/text_field_password.dart';

class LoginUserPass extends StatelessWidget {
  const LoginUserPass({super.key, required GlobalKey<FormState> formKeyLogin})
    : _formKeyLogin = formKeyLogin;

  final GlobalKey<FormState> _formKeyLogin;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.go(Routes.home.description);
        } else if (state is LoginError) {
          _showErrorDialog(context, state.message);
        } else if (state is RecoverCredentialSuccess) {
          showCustomSnackBar(
            context: context,
            message: 'Correo de recuperación enviado con éxito.',
            backgroundColor: context.color.success,
            foregroundColor: context.color.text,
          );
        }
      },
      child: Form(
        key: _formKeyLogin,
        child: Material(
          child: ExpansionTile(
            leading: Icon(Icons.person_3_rounded, color: context.color.secondary),
            title: Text(
              context.loc.userPass,
              style: AppStyles.bodyTextBold.copyWith(color: context.color.secondary),
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.centerLeft,
            trailing: Icon(Icons.arrow_drop_down, color: context.color.secondary),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            collapsedShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            collapsedBackgroundColor: context.color.textSecondary,
            backgroundColor: context.color.textSecondary,
            childrenPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            children: [
              AppVerticalSpace.sm,
              AppText(text: context.loc.email),
              AppVerticalSpace.sm,
              _EmailField(),
              AppVerticalSpace.xmd,
              AppText(text: context.loc.password),
              AppVerticalSpace.sm,
              const TextFieldPassword(),
              AppVerticalSpace.xlg,
              BlocBuilder<LoginBloc, LoginState>(
                buildWhen: (previous, current) =>
                    current is LoginLoading || previous is LoginLoading,
                builder: (context, state) {
                  final isLoading = state is LoginLoading;
                  return AppButton(
                    text: context.loc.login,
                    onPressed: isLoading ? null : () => _handleLogin(context),
                    showIcon: false,
                    enabledButton: !isLoading,
                  );
                },
              ),
              TextButton(
                onPressed: () => _showRecoverPasswordDialog(context),
                child: Text(
                  context.loc.recoverEmail,
                  style: TextStyle(color: context.color.secondary, fontSize: 18),
                ),
              ),
              AppVerticalSpace.md,
              AppButton(
                text: context.loc.register,
                onPressed: () {
                  context.go(Routes.register.description);
                },
                isAlternative: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin(BuildContext context) {
    // Primero validar el formulario de Flutter
    if (!_formKeyLogin.currentState!.validate()) {
      // Si la validación falla, disparar FormValidated para actualizar errores en el BLoC
      context.read<LoginBloc>().add(const FormValidated());
      return;
    }

    // Obtener el BLoC y el estado actual después de la validación del formulario
    final bloc = context.read<LoginBloc>();
    final currentState = bloc.state;

    // Asegurarse de que tenemos un LoginFormState
    if (currentState is! LoginFormState) {
      // Si no es LoginFormState, disparar FormValidated para inicializar el estado
      bloc.add(const FormValidated());
      return;
    }

    final formState = currentState;

    // Validar que tenemos email y password en el estado del BLoC
    if (formState.email.isEmpty || formState.password.isEmpty) {
      // Disparar validación para mostrar errores
      bloc.add(const FormValidated());
      return;
    }

    // Validar que no hay errores de validación en el estado del BLoC
    if (formState.emailError != null || formState.passwordError != null) {
      // Disparar validación para actualizar errores
      bloc.add(const FormValidated());
      return;
    }

    // Si todo está válido, disparar el evento de login con los valores del estado
    bloc.add(
      LoginRequested(
        email: formState.email,
        password: formState.password,
        type: LoginWith.withUserPassword,
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    String mensageUser = errorMessage;

    // Mapear códigos de error a mensajes localizados
    if (errorMessage.contains('weak-password')) {
      mensageUser = context.loc.weakPassword;
    } else if (errorMessage.contains('email-already-in-use')) {
      mensageUser = context.loc.emailAlreadyInUse;
    } else if (errorMessage.contains('user-not-found')) {
      mensageUser = context.loc.userNotFound;
    } else if (errorMessage.contains('wrong-password')) {
      mensageUser = context.loc.wrongPassword;
    } else if (errorMessage.contains('user-disabled')) {
      mensageUser = context.loc.userDisabled;
    } else if (errorMessage.contains('operation-not-allowed')) {
      mensageUser = context.loc.operationNotAllowed;
    } else if (errorMessage.contains('account-exists-with-different-credential')) {
      mensageUser = context.loc.accountExistsWithDifferentCredential;
    } else if (errorMessage.contains('invalid-credential')) {
      mensageUser = context.loc.invalidCredential;
    }

    showAdaptiveDialog(
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

  void _showRecoverPasswordDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: context.color.textSecondary,
      builder: (context) {
        return BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is RecoverCredentialSuccess) {
              Navigator.of(context).pop();
            } else if (state is LoginError) {
              showCustomSnackBar(
                context: context,
                message: state.message,
                backgroundColor: AppColors.red700,
                foregroundColor: AppColors.white,
              );
            }
          },
          child: _RecoverPasswordBottomSheet(),
        );
      },
    );
  }
}

/// Email input field widget that manages state through BLoC.
///
/// Uses a minimal StatefulWidget wrapper only to maintain TextEditingController
/// stability. All business logic is handled by BLoC.
class _EmailField extends StatefulWidget {
  @override
  State<_EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<_EmailField> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listenWhen: (previous, current) {
        if (current is! LoginFormState) return false;
        if (previous is! LoginFormState) return true;
        return previous.email != current.email && _emailController.text != current.email;
      },
      listener: (context, state) {
        final formState = state as LoginFormState;
        if (_emailController.text != formState.email) {
          final selection = _emailController.selection;
          _emailController.value = TextEditingValue(
            text: formState.email,
            selection: selection.isValid
                ? selection
                : TextSelection.collapsed(offset: formState.email.length),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) {
          if (current is! LoginFormState) return false;
          if (previous is! LoginFormState) return true;
          return previous.emailError != current.emailError;
        },
        builder: (context, state) {
          final formState = state is LoginFormState ? state : const LoginFormState();

          return AppTextField(
            hintText: context.loc.enterEmail,
            textEditingController: _emailController,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9@.]'))],
            validator: (value) => formState.emailError,
            onChanged: (value) {
              context.read<LoginBloc>().add(EmailChanged(value));
            },
          );
        },
      ),
    );
  }
}

/// Bottom sheet widget for password recovery.
class _RecoverPasswordBottomSheet extends StatefulWidget {
  @override
  State<_RecoverPasswordBottomSheet> createState() => _RecoverPasswordBottomSheetState();
}

class _RecoverPasswordBottomSheetState extends State<_RecoverPasswordBottomSheet> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.sl,
        right: AppSpacing.sl,
        top: AppSpacing.sl,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.sl,
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.sizeOf(context).height * 0.4,
          child: Column(
            children: [
              AppText(text: context.loc.recoverPassword, fontWeight: FontWeight.bold),
              AppVerticalSpace.md,
              AppText(text: context.loc.recoverAccountMessage),
              AppVerticalSpace.lg,
              AppTextField(hintText: context.loc.email, textEditingController: _emailController),
              AppVerticalSpace.xmd,
              BlocBuilder<LoginBloc, LoginState>(
                buildWhen: (previous, current) =>
                    current is LoginLoading || previous is LoginLoading,
                builder: (context, state) {
                  final isLoading = state is LoginLoading;
                  return AppButton(
                    text: context.loc.send,
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_emailController.text.isEmpty) return;
                            context.read<LoginBloc>().add(
                              RecoverCredentialRequested(_emailController.text),
                            );
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
