import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/modules/register/controller/register_controller.dart';
import 'package:recetasperuanas/modules/register/widget/modern_register_form.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/animated_widgets.dart';
import 'package:recetasperuanas/shared/widget/responsive_constrained_box.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

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

  Future<void> _handleRegister(BuildContext context, AuthUser user, RegisterController con) async {
    await const LoadingDialog().show(
      context,
      future: () async {
        final success = await con.register(user);
        if (success == true) {
          if (!context.mounted) return;
          context.go(Routes.home.description);
        } else {
          if (!context.mounted) return;
          await showAdaptiveDialog(
            context: context,
            builder: (context) {
              return AppModalAlert(
                text: 'Error al registrar usuario. Inténtalo de nuevo.',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterController>(
      builder: (_, RegisterController con, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.color.buttonPrimary.withAlpha(50),
                context.color.error.withAlpha(50),
                context.color.buttonPrimary.withAlpha(50),
                context.color.error.withAlpha(50),
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: ResponsiveConstrainedBox(
                  maxTabletWidth: 450,
                  maxDesktopWidth: 500,
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
                            controller: con,
                            onRegister: (user) => _handleRegister(context, user, con),
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
      },
    );
  }
}
