import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/core/config/config.dart';

class AppTextField<T extends Object> extends StatelessWidget {
  const AppTextField({
    required this.hintText,
    required this.textEditingController,
    super.key,
    this.width,
    this.maxLength,
    this.inputFormatters,
    this.keyboardType,
    this.onChanged,
    this.decoration,
    this.obscuringCharacter,
    this.obscureText,
    this.validator,
    this.suffixIcon,
  });

  final double? width;
  final String hintText;
  final TextEditingController textEditingController;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final InputDecoration? decoration;
  final String? obscuringCharacter;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? _buildCupertinoTextField(context)
        : _buildMaterialTextField(context);
  }

  Widget _buildMaterialTextField(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      obscuringCharacter: obscuringCharacter ?? '*',
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: decoration ?? _defaultInputDecoration(context),
      controller: textEditingController,
      validator: validator,
    );
  }

  Widget _buildCupertinoTextField(BuildContext context) {
    return CupertinoTextFormFieldRow(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      obscureText: obscureText ?? false,
      cursorColor: AppColorScheme.of(context).secondary,
      cursorHeight: 20,
      obscuringCharacter: obscuringCharacter ?? '*',
      controller: textEditingController,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.5, color: AppColors.greyscale200),
      ),
      placeholder: hintText,
      style: TextStyle(height: 2),
      validator: validator,
    );
  }

  InputDecoration _defaultInputDecoration(BuildContext context) {
    return InputDecoration(
      alignLabelWithHint: false,
      hintText: hintText,
      suffixIcon: suffixIcon,
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.greyscale200),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.greyscale700),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.greyscale200),
        borderRadius: BorderRadius.circular(10),
      ),
      errorStyle: const TextStyle(fontSize: 12),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}
