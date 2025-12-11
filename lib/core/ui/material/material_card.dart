import 'package:flutter/material.dart';

/// Card material con propiedades compatibles con la variante Cupertino.
class MaterialCard extends StatelessWidget {
  /// Crea una tarjeta con fondo, borde y padding configurables.
  const MaterialCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.all(12),
    this.margin,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Variante con fondo resaltado (usa `surfaceContainerHighest`).
  factory MaterialCard.filled({
    Key? key,
    required BuildContext context,
    required Widget child,
    Color? borderColor,
    double borderWidth = 1,
    double borderRadius = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.all(12),
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    final colors = Theme.of(context).colorScheme;
    return MaterialCard(
      key: key,
      backgroundColor: colors.surfaceContainerHighest,
      borderColor: borderColor ?? colors.outlineVariant,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      padding: padding,
      margin: margin,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// Contenido interno.
  final Widget child;

  /// Color de fondo de la tarjeta.
  final Color? backgroundColor;

  /// Color del borde.
  final Color? borderColor;

  /// Ancho del borde.
  final double borderWidth;

  /// Radio de borde.
  final double borderRadius;

  /// Espaciado interno.
  final EdgeInsetsGeometry padding;

  /// Margen externo.
  final EdgeInsetsGeometry? margin;

  /// Comportamiento de recorte.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: margin,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor ?? colors.outlineVariant, width: borderWidth),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
