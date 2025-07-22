import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart';
import 'package:recetasperuanas/modules/login/widget/widget.dart';
import 'package:recetasperuanas/shared/widget/animated_widgets.dart';

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

    // Inicializar animaciones
    initializeAnimations();

    // Iniciar animaciones escalonadas
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startStaggeredAnimations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginController>(
      builder: (_, LoginController con, _) {
        return Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double maxWidth = constraints.maxWidth > 600 ? 450 : double.infinity;
                  return FormLogin(
                    maxWidth: maxWidth,
                    formKeyLogin: _formKeyLogin,
                    formAnimation: formAnimation,
                    con: con,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
