import 'package:flutter/material.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

class TextFieldPassword extends StatelessWidget {
  const TextFieldPassword({super.key, required this.con});

  final LoginController con;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: con.isObscureText,
      builder: (BuildContext context, value, Widget? child) {
        return Row(
          children: [
            Expanded(
              child: AppTextField(
                hintText: context.loc.enterPassword,
                textEditingController: con.passwordController,
                obscureText: value,
                obscuringCharacter: '*',
                validator: (value) => con.validatePassword(value ?? '', context),
              ),
            ),
            IconButton(
              onPressed: () {
                con.isObscureText.value = !con.isObscureText.value;
              },
              icon: Icon(
                con.isObscureText.value ? Icons.remove_red_eye_outlined : Icons.remove_red_eye,
              ),
            ),
          ],
        );
      },
    );
  }
}
