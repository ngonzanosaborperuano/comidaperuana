import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/extension/extension.dart';
import 'package:goncook/common/widget/animated_widgets.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/core/router/routes.dart';
import 'package:goncook/features/auth/data/models/auth_user.dart';
import 'package:goncook/features/register/bloc/register_bloc.dart';
import 'package:goncook/features/register/widget/modern_register_form.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with TickerProviderStateMixin, StaggeredAnimationMixin {
  late final GlobalKey<FormState> _formKeyRegister;

  @override
  void initState() {
    super.initState();
    _formKeyRegister = GlobalKey<FormState>();

    // Inicializar animaciones
    initializeAnimations();

    // Iniciar animaciones escalonadas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startStaggeredAnimations();
    });
  }

  Future<void> _handleRegister(BuildContext context, AuthUser user) async {
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

  @override
  Widget build(BuildContext context) {
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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.color.buttonPrimary.withAlpha(150),
              context.color.error.withAlpha(50),
              context.color.buttonPrimary.withAlpha(50),
              context.color.error.withAlpha(150),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Container(
                decoration: BoxDecoration(
                  color: context.color.background,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: context.color.border.withAlpha(50), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: context.color.border.withAlpha(50),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: ModernRegisterForm(
                        formKey: _formKeyRegister,
                        onRegister: (user) => _handleRegister(context, user),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
