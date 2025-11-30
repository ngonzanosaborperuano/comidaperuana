import 'package:flutter/material.dart';
import 'package:goncook/common/controller/base_controller.dart';
import 'package:goncook/common/widget/animated_widgets.dart' show AnimatedEntryWidget;
import 'package:goncook/common/widget/widget.dart' show AppTextField;
import 'package:goncook/features/auth/presentation/widget/widget.dart' show AnimatedLoginForm;

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
