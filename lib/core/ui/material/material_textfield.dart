import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campo de texto Material alineado a propiedades compatibles con Cupertino.
class MaterialTextField extends StatelessWidget {
  const MaterialTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLines = 1,
    this.enabled = true,
    this.autofocus = false,
    this.readOnly = false,
    this.onChanged,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  });

  /// Campo preconfigurado para teléfono.
  factory MaterialTextField.phone({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return MaterialTextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      prefix: prefix,
      suffix: suffix,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  /// Campo preconfigurado para contraseña.
  factory MaterialTextField.password({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return MaterialTextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      prefix: prefix,
      suffix: suffix,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      obscureText: true,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  /// Campo preconfigurado para email.
  factory MaterialTextField.email({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return MaterialTextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      prefix: prefix,
      suffix: suffix,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.none,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  /// Campo preconfigurado numérico.
  factory MaterialTextField.numeric({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return MaterialTextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      prefix: prefix,
      suffix: suffix,
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: false),
      textInputAction: TextInputAction.next,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  /// Campo preconfigurado multilinea.
  factory MaterialTextField.multiline({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return MaterialTextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      prefix: prefix,
      suffix: suffix,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLines: 5,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  /// Campo preconfigurado para búsqueda.
  factory MaterialTextField.search({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return MaterialTextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      prefix: prefix,
      suffix: suffix,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  /// Acción de texto.
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLines;
  final bool enabled;
  final bool autofocus;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      maxLines: maxLines,
      enabled: enabled,
      autofocus: autofocus,
      readOnly: readOnly,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefix,
        suffixIcon: suffix,
        contentPadding: contentPadding,
        filled: true,
        fillColor: colors.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary),
        ),
      ),
    );
  }
}
