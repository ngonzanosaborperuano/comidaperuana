import 'package:flutter/cupertino.dart';
import 'package:goncook/core/extension/extension.dart';

/// Scaffold cupertino configurable que usa los colores por defecto del tema
/// y permite personalizar fondos y barras cuando se requiera.
class CupertinoScaffold extends StatelessWidget {
  /// Crea un contenedor de pantalla basado en `CupertinoPageScaffold`
  /// con colores personalizables que por defecto toman el tema activo.
  const CupertinoScaffold({
    super.key,
    this.navigationBar,
    this.child,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
  });

  /// Barra de navegación superior estilo iOS.
  final ObstructingPreferredSizeWidget? navigationBar;

  /// Contenido principal de la pantalla.
  final Widget? child;

  /// Color de fondo; si no se especifica usa `CupertinoTheme` actual.
  final Color? backgroundColor;

  /// Controla si ajusta el contenido al aparecer el teclado.
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final defaultBackground = context.color.background;

    return CupertinoPageScaffold(
      navigationBar: navigationBar,
      backgroundColor: backgroundColor ?? defaultBackground,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      child: child ?? const SizedBox.shrink(),
    );
  }
}

