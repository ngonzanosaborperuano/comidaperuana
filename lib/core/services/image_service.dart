import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Servicio para gestionar archivos de imagen de manera eficiente
class ImageService {
  static final ImageService _instance = ImageService._internal();
  factory ImageService() => _instance;
  ImageService._internal();

  // Cache para almacenar imágenes cargadas
  final Map<String, Widget> _imageCache = {};
  final Map<String, Uint8List> _imageBytesCache = {};

  /// Carga una imagen desde assets y la cachea
  Future<Widget> loadImageFromAssets(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    BlendMode? colorBlendMode,
  }) async {
    final cacheKey =
        '${assetPath}_${width}_${height}_${fit.index}_${color?.toARGB32()}_${colorBlendMode?.index}';

    if (_imageCache.containsKey(cacheKey)) {
      return _imageCache[cacheKey]!;
    }

    try {
      final widget = Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget(assetPath, width, height);
        },
      );

      _imageCache[cacheKey] = widget;
      return widget;
    } catch (e) {
      debugPrint('Error loading image from assets: $assetPath - $e');
      return _buildErrorWidget(assetPath, width, height);
    }
  }

  /// Carga una imagen desde bytes y la cachea
  Future<Widget> loadImageFromBytes(
    Uint8List bytes, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    BlendMode? colorBlendMode,
  }) async {
    final cacheKey =
        'bytes_${bytes.hashCode}_${width}_${height}_${fit.index}_${color?.toARGB32()}_${colorBlendMode?.index}';

    if (_imageCache.containsKey(cacheKey)) {
      return _imageCache[cacheKey]!;
    }

    try {
      final widget = Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget('bytes', width, height);
        },
      );

      _imageCache[cacheKey] = widget;
      return widget;
    } catch (e) {
      debugPrint('Error loading image from bytes: $e');
      return _buildErrorWidget('bytes', width, height);
    }
  }

  /// Carga una imagen desde network y la cachea
  Future<Widget> loadImageFromNetwork(
    String url, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    BlendMode? colorBlendMode,
    Map<String, String>? headers,
  }) async {
    final cacheKey =
        'network_${url.hashCode}_${width}_${height}_${fit.index}_${color?.toARGB32()}_${colorBlendMode?.index}';

    if (_imageCache.containsKey(cacheKey)) {
      return _imageCache[cacheKey]!;
    }

    try {
      final widget = Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        headers: headers,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget(url, width, height);
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: width,
            height: height,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      );

      _imageCache[cacheKey] = widget;
      return widget;
    } catch (e) {
      debugPrint('Error loading image from network: $url - $e');
      return _buildErrorWidget(url, width, height);
    }
  }

  /// Obtiene los bytes de una imagen desde assets
  Future<Uint8List> getImageBytesFromAssets(String assetPath) async {
    if (_imageBytesCache.containsKey(assetPath)) {
      return _imageBytesCache[assetPath]!;
    }

    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      _imageBytesCache[assetPath] = bytes;
      return bytes;
    } catch (e) {
      debugPrint('Error loading image bytes from assets: $assetPath - $e');
      return Uint8List(0);
    }
  }

  /// Precachea una imagen para uso futuro
  Future<void> precacheImageAsset(String assetPath, BuildContext context) async {
    try {
      await precacheImage(AssetImage(assetPath), context);
    } catch (e) {
      debugPrint('Error precaching image: $assetPath - $e');
    }
  }

  /// Limpia el cache de imágenes
  void clearCache() {
    _imageCache.clear();
    _imageBytesCache.clear();
  }

  /// Limpia una imagen específica del cache
  void clearImageFromCache(String assetPath) {
    final keysToRemove = _imageCache.keys.where((key) => key.startsWith(assetPath)).toList();
    for (final key in keysToRemove) {
      _imageCache.remove(key);
    }
    _imageBytesCache.remove(assetPath);
  }

  /// Obtiene el tamaño del cache
  int get cacheSize => _imageCache.length;

  /// Widget de error cuando falla la carga de la imagen
  Widget _buildErrorWidget(String source, double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
      child: Icon(
        Icons.image_not_supported,
        color: Colors.grey[600],
        size: width != null ? width * 0.5 : 24,
      ),
    );
  }
}
