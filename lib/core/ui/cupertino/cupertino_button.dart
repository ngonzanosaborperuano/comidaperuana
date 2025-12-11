import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:goncook/core/extension/extension.dart';

/// Botón cupertino con propiedades alineadas a la versión Material.
class CupertinoAdaptiveButton extends StatelessWidget {
  /// Crea un botón estilo iOS con parámetros compatibles con Material.
  const CupertinoAdaptiveButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.borderRadius = 12,
    this.minimumSize = const Size.fromHeight(44),
    this.alignment = Alignment.center,
  });

  /// Botón primario usando `context.color.primary` por defecto.
  factory CupertinoAdaptiveButton.primary({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double borderRadius = 12,
    Size minimumSize = const Size.fromHeight(44),
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return CupertinoAdaptiveButton(
      key: key,
      onPressed: onPressed,
      padding: padding,
      borderRadius: borderRadius,
      minimumSize: minimumSize,
      alignment: alignment,
      child: child,
    );
  }

  /// Botón de contorno con fondo transparente y borde visible.
  factory CupertinoAdaptiveButton.outline({
    Key? key,
    required VoidCallback? onPressed,
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double borderRadius = 12,
    Size minimumSize = const Size.fromHeight(44),
    AlignmentGeometry alignment = Alignment.center,
  }) {
    final colors = CupertinoTheme.of(context);
    return CupertinoAdaptiveButton(
      key: key,
      onPressed: onPressed,
      padding: padding,
      backgroundColor: Colors.transparent,
      disabledBackgroundColor: Colors.transparent,
      foregroundColor: colors.primaryColor,
      disabledForegroundColor: colors.primaryContrastingColor,
      borderRadius: borderRadius,
      minimumSize: minimumSize,
      alignment: alignment,
      child: child,
    );
  }

  /// Botón tipo texto, sin fondo ni borde.
  factory CupertinoAdaptiveButton.text({
    Key? key,
    required VoidCallback? onPressed,
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    Size minimumSize = const Size.fromHeight(44),
    AlignmentGeometry alignment = Alignment.center,
  }) {
    final colors = CupertinoTheme.of(context);
    return CupertinoAdaptiveButton(
      key: key,
      onPressed: onPressed,
      padding: padding,
      backgroundColor: Colors.transparent,
      disabledBackgroundColor: Colors.transparent,
      foregroundColor: colors.primaryColor,
      disabledForegroundColor: colors.primaryContrastingColor,
      borderRadius: 0,
      minimumSize: minimumSize,
      alignment: alignment,
      child: child,
    );
  }

  /// Botón selector (chip) con fondo tenue y borde suavizado.
  factory CupertinoAdaptiveButton.selector({
    Key? key,
    required VoidCallback? onPressed,
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double borderRadius = 16,
    Size minimumSize = const Size.fromHeight(36),
    AlignmentGeometry alignment = Alignment.center,
  }) {
    final colors = CupertinoTheme.of(context);
    return CupertinoAdaptiveButton(
      key: key,
      onPressed: onPressed,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      backgroundColor: colors.scaffoldBackgroundColor.withValues(alpha: 0.8),
      disabledBackgroundColor: colors.scaffoldBackgroundColor.withValues(alpha: 0.8),
      foregroundColor: colors.primaryColor,
      disabledForegroundColor: colors.primaryContrastingColor,
      borderRadius: borderRadius,
      minimumSize: minimumSize,
      alignment: alignment,
      child: child,
    );
  }

  /// Acción al presionar; si es null se muestra estado deshabilitado.
  final VoidCallback? onPressed;

  /// Contenido del botón.
  final Widget child;

  /// Relleno interno; si no se provee usa padding por defecto de Cupertino.
  final EdgeInsetsGeometry? padding;

  /// Color de fondo activo; por defecto usa `context.color.primary`.
  final Color? backgroundColor;

  /// Color de fondo deshabilitado.
  final Color? disabledBackgroundColor;

  /// Color de contenido activo (texto/íconos); por defecto usa onPrimary.
  final Color? foregroundColor;

  /// Color de contenido deshabilitado.
  final Color? disabledForegroundColor;

  /// Radio de borde en dp.
  final double borderRadius;

  /// Tamaño mínimo del botón.
  final Size? minimumSize;

  /// Alineación interna.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final colors = CupertinoTheme.of(context);
    final baseBg = backgroundColor ?? context.color.primary;
    final baseFg = foregroundColor ?? colors.primaryColor;
    final disabledBg = disabledBackgroundColor ?? colors.barBackgroundColor;
    final disabledFg = disabledForegroundColor ?? colors.primaryContrastingColor;

    return CupertinoButton(
      onPressed: onPressed,
      padding: padding,
      color: baseBg,
      disabledColor: disabledBg,
      minimumSize: minimumSize,
      alignment: alignment,
      borderRadius: BorderRadius.circular(borderRadius),
      child: DefaultTextStyle(
        style: TextStyle(color: onPressed == null ? disabledFg : baseFg),
        child: IconTheme(
          data: IconThemeData(color: onPressed == null ? disabledFg : baseFg),
          child: child,
        ),
      ),
    );
  }
}
