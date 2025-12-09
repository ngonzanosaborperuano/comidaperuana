import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goncook/core/config/color/app_colors.dart';
import 'package:goncook/core/extension/extension.dart';

/// Widget de campo de texto personalizado y reutilizable
///
/// Proporciona un TextFormField consistente con el tema de la aplicación,
/// con amplia customización para diferentes casos de uso como:
/// - Email, contraseña, texto general, números, etc.
/// - Validación incorporada para casos comunes
/// - Soporte para prefijos, sufijos e iconos
/// - Estados de loading y error
/// - Formatters personalizados
class AppTextFormField extends StatefulWidget {
  /// Controller del campo de texto
  final TextEditingController? controller;

  /// Valor inicial del campo (solo usar si no hay controller)
  final String? initialValue;

  /// Texto de etiqueta del campo
  final String? labelText;

  /// Texto de placeholder/hint
  final String? hintText;

  /// Texto de ayuda mostrado debajo del campo
  final String? helperText;

  /// Función de validación personalizada
  final String? Function(String?)? validator;

  /// Función llamada cuando el valor cambia
  final void Function(String)? onChanged;

  /// Función llamada cuando se toca el campo
  final VoidCallback? onTap;

  /// Tipo de teclado a mostrar
  final TextInputType keyboardType;

  /// Acción del botón de entrada del teclado
  final TextInputAction textInputAction;

  /// Si el campo debe ocultar el texto (para contraseñas)
  final bool obscureText;

  /// Si el campo está habilitado
  final bool enabled;

  /// Si el campo es de solo lectura
  final bool readOnly;

  /// Si el campo es requerido (afecta el estilo del label)
  final bool isRequired;

  /// Número máximo de líneas (null para ilimitado)
  final int? maxLines;

  /// Número mínimo de líneas
  final int minLines;

  /// Longitud máxima del texto
  final int? maxLength;

  /// Widget de icono para prefijo
  final Widget? prefixIcon;

  /// Widget de icono para sufijo
  final Widget? suffixIcon;

  /// Texto de prefijo
  final String? prefixText;

  /// Texto de sufijo
  final String? suffixText;

  /// Lista de formatters para el input
  final List<TextInputFormatter>? inputFormatters;

  /// Estilo del texto
  final TextStyle? textStyle;

  /// Color del borde cuando está enfocado
  final Color? focusedBorderColor;

  /// Color del borde cuando hay error
  final Color? errorBorderColor;

  /// Si debe mostrar el contador de caracteres
  final bool showCounter;

  /// Si debe mostrar el contador como sufijo en formato "00/10"
  final bool showCounterAsSuffix;

  /// Si debe auto-enfocar el campo
  final bool autofocus;

  /// Capitalización del texto
  final TextCapitalization textCapitalization;

  /// Tipo de autocorrección
  final bool autocorrect;

  /// Si debe habilitar sugerencias
  final bool enableSuggestions;

  /// Radio del borde
  final double? borderRadius;

  /// Padding interno del campo
  final EdgeInsetsGeometry? contentPadding;

  /// Tipo de validación predefinida
  final TextFieldValidationType? validationType;

  /// Si debe mostrar toggle para contraseña
  final bool showPasswordToggle;

  /// Estado de loading
  final bool isLoading;

  /// Mensaje de error personalizado (overrides validator)
  final String? errorText;

  const AppTextFormField({
    super.key,
    this.controller,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.helperText,
    this.validator,
    this.onChanged,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.isRequired = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.inputFormatters,
    this.textStyle,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.showCounter = false,
    this.showCounterAsSuffix = false,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.borderRadius,
    this.contentPadding,
    this.validationType,
    this.showPasswordToggle = false,
    this.isLoading = false,
    this.errorText,
  }) : assert(
         controller == null || initialValue == null,
         'Cannot provide both controller and initialValue',
       );

  /// Factory method para crear un campo de email con validación automática
  static AppTextFormField email({
    Key? key,
    TextEditingController? controller,
    String? initialValue,
    String? labelText = 'Email',
    String? hintText = 'ejemplo@correo.com',
    void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
    bool required = false,
    bool isLoading = false,
    String? errorText,
  }) {
    return AppTextFormField(
      key: key,
      controller: controller,
      initialValue: initialValue,
      labelText: labelText,
      hintText: hintText,
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validationType: TextFieldValidationType.email,
      autocorrect: false,
      enableSuggestions: false,
      isRequired: required,
      errorText: errorText,
      isLoading: isLoading,
    );
  }

  /// Factory method para crear un campo de contraseña con toggle de visibilidad
  static AppTextFormField password({
    Key? key,
    TextEditingController? controller,
    String? labelText = 'Contraseña',
    String? hintText = 'Ingresa tu contraseña',
    void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
    bool required = false,
    bool isLoading = false,
    int maxLength = 6,
    bool showCounterAsSuffix = true,
    String? errorText,
  }) {
    return AppTextFormField(
      key: key,
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      onChanged: onChanged,
      //keyboardType: TextInputType.number,
      obscureText: true,
      showPasswordToggle: true,
      validationType: TextFieldValidationType.password,
      autocorrect: false,
      enableSuggestions: false,
      isRequired: required,
      isLoading: isLoading,
      errorText: errorText,
      maxLength: maxLength,
      showCounterAsSuffix: showCounterAsSuffix,
    );
  }

  /// Factory method para crear un campo de teléfono con formateo automático
  static AppTextFormField phone({
    Key? key,
    TextEditingController? controller,
    String? initialValue,
    String? labelText = 'Número de celular',
    String? hintText = '+1234567890',
    void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
    int? maxLength,
    bool required = false,
    bool isLoading = false,
    bool showCounterAsSuffix = false,
    String? errorText,
  }) {
    return AppTextFormField(
      key: key,
      controller: controller,
      initialValue: initialValue,
      labelText: labelText,
      hintText: hintText,
      onChanged: onChanged,
      keyboardType: TextInputType.phone,
      maxLength: maxLength,
      textInputAction: TextInputAction.next,
      validationType: TextFieldValidationType.phone,
      isRequired: required,
      isLoading: isLoading,
      showCounter: maxLength != null && !showCounterAsSuffix,
      showCounterAsSuffix: showCounterAsSuffix,
      errorText: errorText,
      textStyle: const TextStyle(color: AppColors.text2, fontWeight: FontWeight.w700),
    );
  }

  /// Factory method para crear un campo numérico
  static AppTextFormField numeric({
    Key? key,
    TextEditingController? controller,
    String? initialValue,
    String? labelText,
    String? hintText,
    void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
    bool allowDecimals = true,
    bool required = false,
    bool isLoading = false,
    int? maxLength,
    bool showCounterAsSuffix = false,
    String? errorText,
  }) {
    return AppTextFormField(
      key: key,
      controller: controller,
      initialValue: initialValue,
      labelText: labelText,
      hintText: hintText,
      onChanged: onChanged,
      keyboardType: allowDecimals
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      textInputAction: TextInputAction.next,
      validationType: TextFieldValidationType.numeric,
      inputFormatters: allowDecimals
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]'))]
          : [FilteringTextInputFormatter.digitsOnly],
      isRequired: required,
      isLoading: isLoading,
      maxLength: maxLength,
      showCounter: maxLength != null && !showCounterAsSuffix,
      showCounterAsSuffix: showCounterAsSuffix,
      errorText: errorText,
    );
  }

  /// Factory method para crear un campo de texto multilinea
  static AppTextFormField multiline({
    Key? key,
    TextEditingController? controller,
    String? labelText,
    String? hintText,
    void Function(String)? onChanged,
    int maxLines = 4,
    int minLines = 2,
    int? maxLength,
    bool required = false,
    bool isLoading = false,
    bool showCounterAsSuffix = false,
  }) {
    return AppTextFormField(
      key: key,
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      onChanged: onChanged,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      showCounter: maxLength != null && !showCounterAsSuffix,
      showCounterAsSuffix: showCounterAsSuffix,
      validationType: required ? TextFieldValidationType.required : null,
      isRequired: required,
      isLoading: isLoading,
    );
  }

  /// Factory method para crear un campo de búsqueda
  static AppTextFormField search({
    Key? key,
    TextEditingController? controller,
    String? labelText = 'Buscar',
    String? hintText = 'Escribe para buscar...',
    void Function(String)? onChanged,
    void Function(String)? onFieldSubmitted,
    VoidCallback? onClear,
    bool isLoading = false,
  }) {
    return AppTextFormField(
      key: key,
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      onChanged: onChanged,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      suffixIcon: onClear != null
          ? IconButton(icon: const Icon(Icons.clear), onPressed: onClear)
          : null,
      isLoading: isLoading,
    );
  }

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  int _currentLength = 0;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = FocusNode();
    _currentLength = widget.controller?.text.length ?? 0;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  /// Obtiene el validator apropiado basado en el tipo de validación
  String? Function(String?)? get _getValidator {
    if (widget.validator != null) {
      return widget.validator;
    }

    if (widget.validationType != null) {
      return _getPrebuiltValidator(widget.validationType!);
    }

    return null;
  }

  /// Validadores predefinidos para casos comunes
  String? Function(String?) _getPrebuiltValidator(TextFieldValidationType type) {
    switch (type) {
      case TextFieldValidationType.email:
        return (value) {
          if (value?.trim().isEmpty ?? true) {
            return 'El email es requerido';
          }
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
            return 'Formato de email inválido';
          }
          return null;
        };

      case TextFieldValidationType.password:
        return (value) {
          if (value?.isEmpty ?? true) {
            return 'La contraseña es requerida';
          }
          if (value!.length < 6) {
            return 'La contraseña debe tener al menos 6 caracteres';
          }
          return null;
        };

      case TextFieldValidationType.required:
        return (value) {
          if (value?.trim().isEmpty ?? true) {
            return 'Este campo es requerido';
          }
          return null;
        };

      case TextFieldValidationType.phone:
        return (value) {
          if (value?.trim().isEmpty ?? true) {
            return 'El teléfono es requerido';
          }
          return null;
        };

      case TextFieldValidationType.numeric:
        return (value) {
          if (value?.trim().isEmpty ?? true) {
            return 'Este campo es requerido';
          }
          if (double.tryParse(value!) == null) {
            return 'Solo se permiten números';
          }
          return null;
        };

      case TextFieldValidationType.name:
        return (value) {
          if (value?.trim().isEmpty ?? true) {
            return 'El nombre es requerido';
          }
          if (value!.trim().length < 2) {
            return 'El nombre debe tener al menos 2 caracteres';
          }
          return null;
        };
    }
  }

  void _handleTextChanged(String value) {
    setState(() {
      _currentLength = value.length;
    });

    widget.onChanged?.call(value);
  }

  /// Obtiene el texto del sufijo (contador o suffixText personalizado)
  String? get _getSuffixText {
    if (widget.showCounterAsSuffix && widget.maxLength != null) {
      return '${_currentLength.toString().padLeft(2, '0')}/${widget.maxLength.toString().padLeft(2, '0')}';
    }
    return widget.suffixText;
  }

  /// Construye el icono de sufijo apropiado
  Widget? get _buildSuffixIcon {
    if (widget.isLoading) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (widget.showPasswordToggle &&
        (widget.obscureText || widget.validationType == TextFieldValidationType.password)) {
      return IconButton(
        icon: Icon(_obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        color: context.color.textSecondary,
      );
    }

    return widget.suffixIcon;
  }

  /// Construye la decoración del input
  InputDecoration get _buildDecoration {
    return InputDecoration(
      labelText: widget.isRequired && widget.labelText != null
          ? '${widget.labelText}'
          : widget.labelText,
      hintText: widget.hintText,
      helperText: widget.helperText,
      errorText: widget.errorText,
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildSuffixIcon,
      prefixText: widget.prefixText,
      fillColor: context.color.background,
      suffixText: _getSuffixText, //
      enabled: widget.enabled,
      counterText: '', // widget.showCounterAsSuffix ? '' : null,
      contentPadding: widget.contentPadding,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
        borderSide: BorderSide(color: context.color.textNormal),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
        borderSide: BorderSide(color: context.color.textNormal),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
        borderSide: BorderSide(color: widget.focusedBorderColor ?? AppColors.primary1, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
        borderSide: BorderSide(color: widget.errorBorderColor ?? AppColors.error, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
        borderSide: BorderSide(color: widget.errorBorderColor ?? AppColors.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 16),
        borderSide: BorderSide(color: context.color.textNormal),
      ),
      hintStyle: TextStyle(color: context.color.textSecondary, fontWeight: FontWeight.w800),
      labelStyle: TextStyle(color: context.color.textSecondary, fontWeight: FontWeight.w800),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.009),
      child: TextFormField(
        keyboardAppearance: Theme.of(context).brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light,
        controller: widget.controller,
        initialValue: widget.controller == null ? widget.initialValue : null,
        focusNode: widget.readOnly ? null : _focusNode, // Sin focus para readOnly
        validator: _getValidator,
        onChanged: widget.showCounterAsSuffix ? _handleTextChanged : widget.onChanged,
        onTap: widget.onTap,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        obscureText: _obscureText,
        enabled: widget.enabled && !widget.isLoading,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        inputFormatters: widget.inputFormatters,
        style:
            widget.textStyle ??
            TextStyle(color: context.color.textSecondary, fontWeight: FontWeight.w700),
        autofocus: widget.autofocus,
        textCapitalization: widget.textCapitalization,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.enableSuggestions,
        decoration: _buildDecoration,
      ),
    );
  }
}

/// Enum para tipos de validación predefinidos
enum TextFieldValidationType {
  /// Validación de email
  email,

  /// Validación de contraseña (mínimo 6 caracteres)
  password,

  /// Campo requerido (no vacío)
  required,

  /// Validación de teléfono
  phone,

  /// Solo números
  numeric,

  /// Validación de nombre (mínimo 2 caracteres)
  name,
}
