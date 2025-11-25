import 'package:flutter/material.dart';
import 'package:goncook/src/infrastructure/shared/services/image_service.dart';

/// Mapeo de nombres semánticos a rutas de archivos de imagen
class AppImages {
  // Imágenes de la aplicación
  static const String avatar = 'assets/img/avatar.png';
  static const String cocinera = 'assets/img/cocinera.png';
  static const String google = 'assets/img/google.png';
  static const String ia = 'assets/img/ia.png';
  static const String icon = 'assets/img/icon.png';
  static const String init = 'assets/img/init.png';
  static const String logo = 'assets/img/logo.png';
  static const String logoOld = 'assets/img/logo_old.png';
  static const String logoOutName = 'assets/img/logoOutName.png';
  static const String logoOutNameOld = 'assets/img/logoOutName_old.png';
  static const String userAvatar = 'assets/img/user_avatar.png';

  // Método para obtener la ruta por nombre
  static String? getPath(String name) {
    switch (name.toLowerCase()) {
      case 'avatar':
        return avatar;
      case 'cocinera':
        return cocinera;
      case 'google':
        return google;
      case 'ia':
        return ia;
      case 'icon':
        return icon;
      case 'init':
        return init;
      case 'logo':
        return logo;
      case 'logoold':
      case 'logo_old':
        return logoOld;
      case 'logooutname':
      case 'logo_out_name':
        return logoOutName;
      case 'logooutnameold':
      case 'logo_out_name_old':
        return logoOutNameOld;
      case 'useravatar':
      case 'user_avatar':
        return userAvatar;
      default:
        return null;
    }
  }
}

/// Widget personalizado para mostrar imágenes con gestión automática de cache
class AppImage extends StatefulWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;
  final BlendMode? colorBlendMode;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
    this.fit = BoxFit.contain,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<AppImage> createState() => _AppImageState();
}

class _AppImageState extends State<AppImage> {
  Widget? _imageWidget;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(AppImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath ||
        oldWidget.color != widget.color ||
        oldWidget.colorBlendMode != widget.colorBlendMode ||
        oldWidget.width != widget.width ||
        oldWidget.height != widget.height ||
        oldWidget.fit != widget.fit) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final imageWidget = await context.imageService.loadImageFromAssets(
        widget.assetPath,
        width: widget.width,
        height: widget.height,
        color: widget.color,
        colorBlendMode: widget.colorBlendMode,
        fit: widget.fit,
      );

      if (mounted) {
        setState(() {
          _imageWidget = imageWidget;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ??
          SizedBox(
            width: widget.width,
            height: widget.height,
            child: const Center(child: CircularProgressIndicator()),
          );
    }

    if (_hasError) {
      return widget.errorWidget ??
          Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              Icons.image_not_supported,
              color: Colors.grey[600],
              size: widget.width != null ? widget.width! * 0.5 : 24,
            ),
          );
    }

    return _imageWidget ?? const SizedBox.shrink();
  }
}

/// Widget para imagen con ícono (especialmente para avatares y logos)
class AppImageIcon extends StatelessWidget {
  final String assetPath;
  final double? size;
  final Color? color;
  final BlendMode? colorBlendMode;
  final BoxFit fit;

  const AppImageIcon({
    super.key,
    required this.assetPath,
    this.size,
    this.color,
    this.colorBlendMode,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return AppImage(
      assetPath: assetPath,
      width: size,
      height: size,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      placeholder: SizedBox(
        width: size,
        height: size,
        child: const Center(
          child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      ),
      errorWidget: SizedBox(
        width: size,
        height: size,
        child: Icon(
          Icons.image_not_supported,
          size: size != null ? size! * 0.6 : 20,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}

/// Extension para facilitar el uso de imágenes
extension AppImageExtension on BuildContext {
  AppImageIcon imageIcon(
    String assetPath, {
    double? size,
    Color? color,
    BlendMode? colorBlendMode,
  }) {
    return AppImageIcon(
      assetPath: assetPath,
      size: size,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }

  AppImage imageWidget(
    String assetPath, {
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
  }) {
    return AppImage(
      assetPath: assetPath,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }

  /// Extension semántica para imágenes usando nombres
  ImageIconSemantic get image => ImageIconSemantic(this);
}

/// Clase para uso semántico de imágenes
class ImageIconSemantic {
  final BuildContext context;

  ImageIconSemantic(this.context);

  /// Imagen avatar
  AppImageIcon avatar({double? size, Color? color, BlendMode? colorBlendMode}) {
    return AppImageIcon(
      assetPath: AppImages.avatar,
      size: size,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }

  /// Imagen cocinera
  AppImageIcon cocinera({double? size, Color? color, BlendMode? colorBlendMode}) {
    return AppImageIcon(
      assetPath: AppImages.cocinera,
      size: size,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }

  /// Imagen google
  AppImageIcon google({double? size, Color? color, BlendMode? colorBlendMode}) {
    return AppImageIcon(
      assetPath: AppImages.google,
      size: size,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }

  /// Imagen ia
  AppImageIcon ia({double? size, Color? color, BlendMode? colorBlendMode}) {
    return AppImageIcon(
      assetPath: AppImages.ia,
      size: size,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }

  /// Imagen icon
  AppImageIcon icon({double? size, Color? color, BlendMode? colorBlendMode}) {
    return AppImageIcon(
      assetPath: AppImages.icon,
      size: size,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }

  /// Imagen init
  AppImageIcon init({double? size, Color? color, BlendMode? colorBlendMode}) {
    return AppImageIcon(
      assetPath: AppImages.init,
      size: size,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }

  /// Imagen logo
  AppImageIcon logo({double? size, Color? color, BlendMode? colorBlendMode}) {
    return AppImageIcon(
      assetPath: AppImages.logo,
      size: size,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }

  /// Imagen logo old
  AppImageIcon logoOld({double? size, Color? color, BlendMode? colorBlendMode}) {
    return AppImageIcon(
      assetPath: AppImages.logoOld,
      size: size,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }

  /// Imagen logo out name
  AppImageIcon logoOutName({double? size, Color? color, BlendMode? colorBlendMode}) {
    return AppImageIcon(
      assetPath: AppImages.logoOutName,
      size: size,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }

  /// Imagen logo out name old
  AppImageIcon logoOutNameOld({double? size, Color? color, BlendMode? colorBlendMode}) {
    return AppImageIcon(
      assetPath: AppImages.logoOutNameOld,
      size: size,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }

  /// Imagen user avatar
  AppImageIcon userAvatar({double? size, Color? color, BlendMode? colorBlendMode}) {
    return AppImageIcon(
      assetPath: AppImages.userAvatar,
      size: size,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }

  /// Método genérico para cualquier imagen por nombre
  AppImageIcon? byName(String name, {double? size, Color? color, BlendMode? colorBlendMode}) {
    final path = AppImages.getPath(name);
    if (path != null) {
      return AppImageIcon(
        assetPath: path,
        size: size,
        color: color,
        colorBlendMode: colorBlendMode,
      );
    }
    return null;
  }
}
