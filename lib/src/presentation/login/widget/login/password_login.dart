import 'package:flutter/material.dart';
import 'package:goncook/src/presentation/core/config/config.dart' show AppStyles;
import 'package:goncook/src/presentation/login/widget/widget.dart' show AnimatedLoginForm;
import 'package:goncook/src/shared/controller/base_controller.dart';
import 'package:goncook/src/shared/widget/animated_widgets.dart' show AnimatedEntryWidget;
import 'package:goncook/src/shared/widget/widget.dart' show AppTextField;

class PasswordLogin extends StatelessWidget {
  const PasswordLogin({super.key, required this.widget});

  final AnimatedLoginForm widget;

  @override
  Widget build(BuildContext context) {
    final isObscureText = ValueNotifier(true);
    return RepaintBoundary(
      child: AnimatedEntryWidget(
        animation: widget.animation,
        slideOffset: const Offset(0.3, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder(
              valueListenable: isObscureText,
              builder: (BuildContext context, bool value, Widget? child) {
                return AppTextField(
                  textEditingController: widget.controller.passwordController,
                  hintText: context.loc.password,
                  obscureText: value,
                  validator: (value) => widget.controller.validatePassword(value ?? '', context),
                );
              },
            ),
            TextButton(
              onPressed: () {
                isObscureText.value = !isObscureText.value;
              },
              child: Text(
                isObscureText.value ? context.loc.showPassword : context.loc.hidePassword,
                style: AppStyles.bodyTextBold.copyWith(color: context.color.text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
