import 'package:flutter/material.dart';
import 'package:goncook/common/controller/base_controller.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/features/auth/controller/login_controller.dart' show LoginController;
import 'package:goncook/features/core/config/style/app_styles.dart';

class TextFieldPassword extends StatelessWidget {
  const TextFieldPassword({super.key, required this.con});

  final LoginController con;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: con.isObscureText,
      builder: (BuildContext context, value, Widget? child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              hintText: context.loc.enterPassword,
              textEditingController: con.passwordController,
              obscureText: value,
              obscuringCharacter: '*',
              prefixIcon: Icon(Icons.lock, color: context.color.textSecondary),
              validator: (value) => con.validatePassword(value ?? '', context),
            ),
            TextButton(
              onPressed: () {
                con.isObscureText.value = !con.isObscureText.value;
              },
              child: Text(
                context.loc.showPassword,
                style: AppStyles.bodyTextBold.copyWith(color: context.color.secondary),
              ),
            ),
          ],
        );
      },
    );
  }
}
