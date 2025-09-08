import 'package:flutter/material.dart';
import 'package:recetasperuanas/src/presentation/login/widget/widget.dart' show AnimatedLoginForm;
import 'package:recetasperuanas/src/shared/controller/base_controller.dart';
import 'package:recetasperuanas/src/shared/widget/animated_widgets.dart' show AnimatedEntryWidget;
import 'package:recetasperuanas/src/shared/widget/widget.dart' show AppTextField;

class EmailLogin extends StatelessWidget {
  const EmailLogin({super.key, required this.widget});

  final AnimatedLoginForm widget;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedEntryWidget(
        animation: widget.animation,
        slideOffset: const Offset(-0.3, 0),
        child: AppTextField(
          textEditingController: widget.controller.emailController,
          hintText: context.loc.email,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => widget.controller.validateEmail(value ?? '', context),
        ),
      ),
    );
  }
}
