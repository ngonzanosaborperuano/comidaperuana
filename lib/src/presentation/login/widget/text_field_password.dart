import 'package:flutter/material.dart';
import 'package:recetasperuanas/src/presentation/core/config/style/app_styles.dart';
import 'package:recetasperuanas/src/presentation/login/controller/login_controller.dart'
    show LoginController;
import 'package:recetasperuanas/src/shared/controller/base_controller.dart';
import 'package:recetasperuanas/src/shared/widget/widget.dart';

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
