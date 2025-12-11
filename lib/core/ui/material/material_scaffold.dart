import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goncook/core/extension/extension.dart';

/// Scaffold material con un conjunto de parámetros alineado a Cupertino
/// para evitar diferencias entre plataformas.
class MaterialScaffold extends StatelessWidget {
  /// Crea un contenedor de pantalla basado en `Scaffold` con parámetros
  /// compatibles con CupertinoPageScaffold.
  const MaterialScaffold({
    super.key,
    this.navigationBar,
    this.child,
    this.resizeToAvoidBottomInset,
    this.backgroundColor,
  });

  /// Barra superior; se mapea a `appBar` en Material y a `navigationBar` en iOS.
  final ObstructingPreferredSizeWidget? navigationBar;

  /// Contenido principal de la pantalla.
  final Widget? child;

  /// Controla si ajusta contenido al teclado. Usa valor por defecto del tema si es null.
  final bool? resizeToAvoidBottomInset;

  /// Color de fondo; si no se especifica usa `colorScheme.background`.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final defaultBackground = context.color.background;

    return Scaffold(
      appBar: navigationBar,
      body: child ?? const SizedBox.shrink(),
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      backgroundColor: backgroundColor ?? defaultBackground,
    );
  }
}

