import 'package:flutter/material.dart';
import 'package:goncook/core/extension/extension.dart';

/// Botón material alineado a las props comunes con `CupertinoButton`
/// para minimizar diferencias entre plataformas.
class MaterialButton extends StatelessWidget {
  /// Crea un botón estilizado que refleja color y padding compatibles
  /// con su contraparte Cupertino.
  const MaterialButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.borderRadius = 12,
    this.minSize = 44,
    this.alignment = Alignment.center,
  });

  /// Crea un botón primario usando `context.color.primary` y texto onPrimary.
  factory MaterialButton.primary({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double borderRadius = 12,
    double minSize = 44,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return MaterialButton(
      key: key,
      onPressed: onPressed,
      padding: padding,
      borderRadius: borderRadius,
      minSize: minSize,
      alignment: alignment,
      child: child,
    );
  }

  /// Crea un botón de contorno usando bordes y fondo transparente.
  factory MaterialButton.outline({
    Key? key,
    required VoidCallback? onPressed,
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double borderRadius = 12,
    double minSize = 44,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    final colors = Theme.of(context).colorScheme;
    return MaterialButton(
      key: key,
      onPressed: onPressed,
      padding: padding,
      backgroundColor: Colors.transparent,
      disabledBackgroundColor: Colors.transparent,
      foregroundColor: colors.primary,
      disabledForegroundColor: colors.onSurface,
      borderRadius: borderRadius,
      minSize: minSize,
      alignment: alignment,
      child: child,
    );
  }

  /// Crea un botón tipo texto sin fondo ni borde.
  factory MaterialButton.text({
    Key? key,
    required VoidCallback? onPressed,
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double minSize = 44,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    final colors = Theme.of(context).colorScheme;
    return MaterialButton(
      key: key,
      onPressed: onPressed,
      padding: padding,
      backgroundColor: Colors.transparent,
      disabledBackgroundColor: Colors.transparent,
      foregroundColor: colors.primary,
      disabledForegroundColor: colors.onSurface,
      borderRadius: 0,
      minSize: minSize,
      alignment: alignment,
      child: child,
    );
  }

  /// Crea un botón selector (chip) con fondo tenue y borde suavizado.
  factory MaterialButton.selector({
    Key? key,
    required VoidCallback? onPressed,
    required BuildContext context,
    required Widget child,
    EdgeInsetsGeometry? padding,
    double borderRadius = 16,
    double minSize = 36,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    final colors = Theme.of(context).colorScheme;
    return MaterialButton(
      key: key,
      onPressed: onPressed,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      backgroundColor: colors.surfaceContainerHighest,
      disabledBackgroundColor: colors.surfaceContainerHighest,
      foregroundColor: colors.onSurface,
      disabledForegroundColor: colors.onSurfaceVariant,
      borderRadius: borderRadius,
      minSize: minSize,
      alignment: alignment,
      child: child,
    );
  }

  /// Acción al presionar; si es null se muestra estado deshabilitado.
  final VoidCallback? onPressed;

  /// Contenido del botón.
  final Widget child;

  /// Relleno interno; si no se provee usa padding por defecto de Material.
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

  /// Alto mínimo del botón.
  final double minSize;

  /// Alineación interna.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final baseBg = backgroundColor ?? context.color.primary;
    final baseFg = foregroundColor ?? colors.onPrimary;
    final disabledBg = disabledBackgroundColor ?? colors.surfaceContainerHighest;
    final disabledFg = disabledForegroundColor ?? colors.onSurface;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minSize),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: padding != null ? WidgetStatePropertyAll(padding) : null,
          alignment: alignment,
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return disabledBg;
            return baseBg;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return disabledFg;
            return baseFg;
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          ),
          elevation: const WidgetStatePropertyAll(0),
        ),
        child: child,
      ),
    );
  }
}
