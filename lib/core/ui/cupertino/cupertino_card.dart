import 'package:flutter/cupertino.dart';

/// Card cupertino con propiedades compatibles con la variante Material.
class CupertinoAdaptiveCard extends StatelessWidget {
  /// Crea una tarjeta con fondo, borde y padding configurables.
  const CupertinoAdaptiveCard({
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

  /// Variante con fondo resaltado (usa `systemGrey6`).
  factory CupertinoAdaptiveCard.filled({
    Key? key,
    required Widget child,
    Color? borderColor,
    double borderWidth = 1,
    double borderRadius = 12,
    EdgeInsetsGeometry padding = const EdgeInsets.all(12),
    EdgeInsetsGeometry? margin,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return CupertinoAdaptiveCard(
      key: key,
      backgroundColor: CupertinoColors.systemGrey6,
      borderColor: borderColor ?? CupertinoColors.separator,
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
    return Container(
      margin: margin,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        color: backgroundColor ?? CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor ?? CupertinoColors.separator, width: borderWidth),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
