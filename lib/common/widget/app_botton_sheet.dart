import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/core/extension/extension.dart';

/// Widget de bottom sheet personalizable que proporciona un diseño consistente
/// en toda la aplicación.
///
/// Este widget sigue el sistema de diseño de la app y puede ser personalizado
/// con varios parámetros para diferentes casos de uso.
class AppBottomSheet extends StatelessWidget {
  /// El contenido a mostrar en el bottom sheet
  final Widget child;

  /// El título mostrado en la parte superior del bottom sheet
  final String? title;

  /// Si mostrar un botón de cerrar (X) en la esquina superior derecha
  final bool showCloseButton;

  /// Función callback cuando se presiona el botón de cerrar
  final VoidCallback? onClose;

  /// Si mostrar un indicador de arrastre (línea) en la parte superior
  final bool showDragHandle;

  /// La altura del bottom sheet (null para altura automática)
  final double? height;

  /// La restricción de altura máxima para el bottom sheet
  final double? maxHeight;

  /// La restricción de altura mínima para el bottom sheet
  final double? minHeight;

  /// Si el bottom sheet puede ser cerrado arrastrando hacia abajo
  final bool isDismissible;

  /// Si el bottom sheet puede ser arrastrado
  final bool enableDrag;

  /// El color de fondo del bottom sheet
  final Color? backgroundColor;

  /// El radio de borde para las esquinas superiores
  final BorderRadius? borderRadius;

  /// Padding alrededor del contenido
  final EdgeInsetsGeometry? contentPadding;

  /// Si mostrar una sombra/elevación
  final bool showShadow;

  /// El valor de elevación cuando la sombra está habilitada
  final double elevation;

  /// Si mostrar un separador debajo del título
  final bool showTitleDivider;

  /// Widget de título personalizado (anula el texto del título si se proporciona)
  final Widget? titleWidget;

  /// Si centrar el título
  final bool centerTitle;

  /// El estilo de texto del título
  final TextStyle? titleStyle;

  /// Si mostrar un botón de regreso en lugar del botón de cerrar
  final bool showBackButton;

  /// Función callback cuando se presiona el botón de regreso
  final VoidCallback? onBack;

  /// El valor de elevación cuando la sombra está habilitada
  final double sigma;

  const AppBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.showCloseButton = true,
    this.onClose,
    this.showDragHandle = false,
    this.height,
    this.maxHeight,
    this.minHeight,
    this.isDismissible = true,
    this.enableDrag = true,
    this.backgroundColor,
    this.borderRadius,
    this.contentPadding,
    this.showShadow = true,
    this.elevation = 8.0,
    this.showTitleDivider = true,
    this.titleWidget,
    this.centerTitle = false,
    this.titleStyle,
    this.showBackButton = false,
    this.onBack,
    this.sigma = 0.0,
  }) : assert(
         !(showCloseButton && showBackButton),
         'No se pueden mostrar ambos botones: cerrar y regreso',
       );

  /// Muestra un bottom sheet de error
  static Future<T?> showError<T>({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onTap,
    Widget child = const SizedBox.shrink(),
    bool isDismissible = true,
    bool enableDrag = true,
    double sigma = 0.0,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlurBackground(
        sigma: sigma,
        child: _AppErrorBottomSheet(
          context: context,
          title: title,
          description: description,
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }

  /// Muestra el bottom sheet como modal
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    bool showCloseButton = true,
    VoidCallback? onClose,
    bool showDragHandle = false,
    double? height,
    double? maxHeight,
    double? minHeight,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    bool showShadow = true,
    double elevation = 8.0,
    bool showTitleDivider = true,
    Widget? titleWidget,
    bool centerTitle = false,
    TextStyle? titleStyle,
    bool showBackButton = false,
    VoidCallback? onBack,
    double sigma = 4,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlurBackground(
        sigma: sigma,
        child: AppBottomSheet(
          title: title,
          showCloseButton: showCloseButton,
          onClose: onClose,
          showDragHandle: showDragHandle,
          height: height,
          maxHeight: maxHeight,
          minHeight: minHeight,
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
          contentPadding: contentPadding,
          showShadow: showShadow,
          elevation: elevation,
          showTitleDivider: showTitleDivider,
          titleWidget: titleWidget,
          centerTitle: centerTitle,
          titleStyle: titleStyle,
          showBackButton: showBackButton,
          onBack: onBack,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      height: height,
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.9,
        minHeight: minHeight ?? 0,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: borderRadius ?? const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: elevation,
                  offset: const Offset(0, -2),
                ),
              ]
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicador de arrastre
          if (showDragHandle) _buildDragHandle(),

          // Encabezado con título y botón de cerrar/regreso
          if (title != null || titleWidget != null || showCloseButton || showBackButton)
            _buildHeader(context, theme, colorScheme),

          // Contenido
          Flexible(
            child: Padding(padding: contentPadding ?? const EdgeInsets.all(16), child: child),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: AppSpacing.xmd,
        bottom: AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Botón de regreso
          if (showBackButton)
            IconButton(
              onPressed: onBack ?? () => context.pop(),
              icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface, size: 25),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),

          // Título
          if (title != null || titleWidget != null)
            Expanded(
              child:
                  titleWidget ??
                  Text(
                    title!,
                    style:
                        titleStyle ??
                        theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                    textAlign: centerTitle ? TextAlign.center : TextAlign.start,
                  ),
            ),

          // Botón de cerrar
          if (showCloseButton)
            InkWell(
              onTap: onClose ?? () => context.pop(),
              child: Icon(Icons.close, color: colorScheme.onSurface, size: 20),
            ),
        ],
      ),
    );
  }
}

class _AppErrorBottomSheet extends AppBottomSheet {
  const _AppErrorBottomSheet({
    required BuildContext context,
    required super.title,
    required this.description,
    required this.onTap,
    super.child = const SizedBox.shrink(),
  });
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.lg,
        children: [
          context.svgIcon(SvgIcons.lock),
          Text(title ?? 'Hubo un error', style: Theme.of(context).textTheme.titleLarge),
          Text(description),
          AppButton.google(text: 'Entendido', onPressed: onTap),
          AppVerticalSpace.xmd,
          child,
        ],
      ),
    );
  }
}

/// Métodos de extensión para un uso más fácil del bottom sheet
extension AppBottomSheetExtension on BuildContext {
  /// Muestra un bottom sheet simple con contenido
  Future<T?> showBottomSheet<T>({
    required Widget child,
    String? title,
    bool showCloseButton = true,
    VoidCallback? onClose,
    bool showDragHandle = false,
    double? height,
    double? maxHeight,
    double? minHeight,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? contentPadding,
    bool showShadow = true,
    double elevation = 8.0,
    bool showTitleDivider = true,
    Widget? titleWidget,
    bool centerTitle = false,
    TextStyle? titleStyle,
    bool showBackButton = false,
    VoidCallback? onBack,
    double sigma = 4,
  }) {
    return AppBottomSheet.show<T>(
      context: this,
      child: child,
      title: title,
      showCloseButton: showCloseButton,
      onClose: onClose,
      showDragHandle: showDragHandle,
      height: height,
      maxHeight: maxHeight,
      minHeight: minHeight,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      contentPadding: contentPadding,
      showShadow: showShadow,
      elevation: elevation,
      showTitleDivider: showTitleDivider,
      titleWidget: titleWidget,
      centerTitle: centerTitle,
      titleStyle: titleStyle,
      showBackButton: showBackButton,
      onBack: onBack,
      sigma: sigma,
    );
  }
}

/// Widget reutilizable para mostrar bottom sheets de error con SVG, título y subtítulo personalizables.
///
/// Este widget proporciona una interfaz consistente para mostrar errores en toda la aplicación,
/// permitiendo personalizar el icono SVG, el título, el subtítulo y la acción del botón.
class AppErrorBottomSheet extends StatelessWidget {
  /// Constructor del widget de error bottom sheet.
  ///
  /// [svgAsset] - Ruta del asset SVG a mostrar (por defecto Assets.errorTransferSvg)
  /// [title] - Título del error (por defecto 'Error')
  /// [subtitle] - Subtítulo descriptivo del error
  /// [buttonText] - Texto del botón de acción (por defecto 'Reintentar')
  /// [onButtonPressed] - Callback ejecutado al presionar el botón (por defecto cierra el bottom sheet)
  /// [svgSize] - Tamaño del SVG (por defecto 100x100)
  const AppErrorBottomSheet({
    super.key,
    this.svgAsset = SvgIcons.lock,
    this.title = 'Error',
    required this.subtitle,
    this.buttonText = 'Reintentar',
    this.onButtonPressed,
    this.svgSize = 100.0,
  });

  /// Asset SVG a mostrar en el bottom sheet.
  final String svgAsset;

  /// Título del error.
  final String title;

  /// Subtítulo descriptivo del error.
  final TextSpan subtitle;

  /// Texto del botón de acción.
  final String buttonText;

  /// Callback ejecutado al presionar el botón.
  final VoidCallback? onButtonPressed;

  /// Tamaño del SVG.
  final double svgSize;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: AppSpacing.md,
      fontWeight: FontWeight.w700,
      color: context.color.buttonPrimary,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xmd,
            right: AppSpacing.xmd,
            bottom: AppSpacing.xmd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(svgAsset, height: svgSize, width: svgSize),
              AppVerticalSpace.xmd,
              Text(title, style: style),
              AppVerticalSpace.xmd,
              RichText(text: subtitle),
            ],
          ),
        ),
        AppButton.google(
          text: buttonText,
          onPressed:
              onButtonPressed ??
              () {
                context.pop();
              },
        ),
        AppVerticalSpace.md,
      ],
    );
  }

  /// Método estático para mostrar el bottom sheet de error de manera conveniente.
  ///
  /// [context] - BuildContext para mostrar el bottom sheet
  /// [svgAsset] - Ruta del asset SVG a mostrar
  /// [title] - Título del error
  /// [subtitle] - Subtítulo descriptivo del error
  /// [buttonText] - Texto del botón de acción
  /// [onButtonPressed] - Callback ejecutado al presionar el botón
  /// [svgSize] - Tamaño del SVG
  static void show(
    BuildContext context, {
    String svgAsset = SvgIcons.lock,
    String title = 'Error',
    required TextSpan subtitle,
    String buttonText = 'Reintentar',
    VoidCallback? onButtonPressed,
    double svgSize = 100.0,
  }) {
    context.showBottomSheet(
      contentPadding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      sigma: 4,
      child: AppErrorBottomSheet(
        svgAsset: svgAsset,
        title: title,
        subtitle: subtitle,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
        svgSize: svgSize,
      ),
    );
  }
}

class BlurBackground extends StatelessWidget {
  final Widget child;
  final double sigma;

  const BlurBackground({super.key, required this.child, this.sigma = 5.0});

  @override
  Widget build(BuildContext context) => BackdropFilter(
    filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
    child: child,
  );
}
