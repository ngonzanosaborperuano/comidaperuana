import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/constants/routes.dart';
import 'package:recetasperuanas/modules/register/controller/register_controller.dart';
import 'package:recetasperuanas/modules/register/widget/animated_avatar.dart';
import 'package:recetasperuanas/modules/register/widget/register_form.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with TickerProviderStateMixin, StaggeredAnimationMixin {
  late final GlobalKey<FormState> _formKeyRegister;
  late final RegisterController con;

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
        this.con = con;
        return Scaffold(
          backgroundColor: context.color.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Botón de regreso con animación fade
                  RepaintBoundary(
                    child: FadeTransition(
                      opacity: fadeAnimation,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.go(Routes.login.description);
                            },
                            icon: Icon(Icons.arrow_back, color: context.color.text),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Avatar animado
                  RepaintBoundary(
                    child: AnimatedScaleWidget(
                      animation: scaleAnimation,
                      child: AnimatedAvatar(
                        onTap: () {
                          // Efecto adicional al tocar el avatar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(context.loc.registerNow),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  AppVerticalSpace.md,

                  // Textos con animación de slide
                  RepaintBoundary(
                    child: AnimatedEntryWidget(
                      animation: fadeAnimation,
                      slideOffset: const Offset(0, 0.3),
                      child: Column(
                        children: [
                          AppText(
                            text: context.loc.registerNow,
                            fontSize: AppSpacing.xxmd,
                            fontWeight: FontWeight.bold,
                            color: context.color.text,
                            textAlign: TextAlign.center,
                          ),
                          AppVerticalSpace.md,
                          AppText(
                            text: context.loc.completeInformation,
                            fontSize: AppSpacing.md,
                            fontWeight: FontWeight.w400,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Formulario con animación fade
                  RepaintBoundary(
                    child: FadeTransition(
                      opacity: formAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(parent: formController, curve: Curves.easeOutCubic),
                        ),
                        child: RegisterForm(
                          formKey: _formKeyRegister,
                          controller: con,
                          onRegister: (user) => _handleRegister(context, user),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
