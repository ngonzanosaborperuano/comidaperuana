import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// Campo de texto Cupertino alineado a propiedades compatibles con Material.
class CupertinoAdaptiveTextField extends StatelessWidget {
  const CupertinoAdaptiveTextField({
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
  factory CupertinoAdaptiveTextField.phone({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return CupertinoAdaptiveTextField(
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
  factory CupertinoAdaptiveTextField.password({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return CupertinoAdaptiveTextField(
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
  factory CupertinoAdaptiveTextField.email({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return CupertinoAdaptiveTextField(
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
  factory CupertinoAdaptiveTextField.numeric({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return CupertinoAdaptiveTextField(
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
  factory CupertinoAdaptiveTextField.multiline({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return CupertinoAdaptiveTextField(
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
  factory CupertinoAdaptiveTextField.search({
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? hintText,
    Widget? prefix,
    Widget? suffix,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return CupertinoAdaptiveTextField(
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
    return CupertinoTextField(
      controller: controller,
      focusNode: focusNode,
      placeholder: hintText,
      prefix: prefix,
      suffix: suffix,
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
      padding: contentPadding,
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.separator),
      ),
    );
  }
}

