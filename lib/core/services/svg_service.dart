import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Servicio para gestionar archivos SVG de manera eficiente
class SvgService {
  static final SvgService _instance = SvgService._internal();
  factory SvgService() => _instance;
  SvgService._internal();

  // Cache para almacenar SVGs cargados
  final Map<String, Widget> _svgCache = {};
  final Map<String, String> _svgStringCache = {};

  /// Carga un SVG desde assets y lo cachea
  Future<Widget> loadSvgFromAssets(
    String assetPath, {
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) async {
    final cacheKey = '${assetPath}_${width}_${height}_${color?.toARGB32()}_${fit.index}';

    if (_svgCache.containsKey(cacheKey)) {
      return _svgCache[cacheKey]!;
    }

    try {
      final widget = SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        fit: fit,
      );

      _svgCache[cacheKey] = widget;
      return widget;
    } catch (e) {
      debugPrint('Error loading SVG from assets: $assetPath - $e');
      return _buildErrorWidget(assetPath, width, height);
    }
  }

  /// Carga un SVG desde string y lo cachea
  Future<Widget> loadSvgFromString(
    String svgString, {
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) async {
    final cacheKey =
        'string_${svgString.hashCode}_${width}_${height}_${color?.toARGB32()}_${fit.index}';

    if (_svgCache.containsKey(cacheKey)) {
      return _svgCache[cacheKey]!;
    }

    try {
      final widget = SvgPicture.string(
        svgString,
        width: width,
        height: height,
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        fit: fit,
      );

      _svgCache[cacheKey] = widget;
      return widget;
    } catch (e) {
      debugPrint('Error loading SVG from string: $e');
      return _buildErrorWidget('string', width, height);
    }
  }

  /// Carga un SVG desde bytes y lo cachea
  Future<Widget> loadSvgFromBytes(
    Uint8List bytes, {
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
  }) async {
    final cacheKey = 'bytes_${bytes.hashCode}_${width}_${height}_${color?.toARGB32()}_${fit.index}';

    if (_svgCache.containsKey(cacheKey)) {
      return _svgCache[cacheKey]!;
    }

    try {
      final widget = SvgPicture.memory(
        bytes,
        width: width,
        height: height,
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        fit: fit,
      );

      _svgCache[cacheKey] = widget;
      return widget;
    } catch (e) {
      debugPrint('Error loading SVG from bytes: $e');
      return _buildErrorWidget('bytes', width, height);
    }
  }

  /// Carga un SVG desde network y lo cachea
  Future<Widget> loadSvgFromNetwork(
    String url, {
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
    Map<String, String>? headers,
  }) async {
    final cacheKey = 'network_${url.hashCode}_${width}_${height}_${color?.toARGB32()}_${fit.index}';

    if (_svgCache.containsKey(cacheKey)) {
      return _svgCache[cacheKey]!;
    }

    try {
      final widget = SvgPicture.network(
        url,
        width: width,
        height: height,
        colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
        fit: fit,
        headers: headers,
      );

      _svgCache[cacheKey] = widget;
      return widget;
    } catch (e) {
      debugPrint('Error loading SVG from network: $url - $e');
      return _buildErrorWidget(url, width, height);
    }
  }

  /// Obtiene el string de un SVG desde assets
  Future<String> getSvgStringFromAssets(String assetPath) async {
    if (_svgStringCache.containsKey(assetPath)) {
      return _svgStringCache[assetPath]!;
    }

    try {
      final String svgString = await rootBundle.loadString(assetPath);
      _svgStringCache[assetPath] = svgString;
      return svgString;
    } catch (e) {
      debugPrint('Error loading SVG string from assets: $assetPath - $e');
      return '';
    }
  }

  /// Limpia el cache de SVGs
  void clearCache() {
    _svgCache.clear();
    _svgStringCache.clear();
  }

  /// Limpia un SVG específico del cache
  void clearSvgFromCache(String assetPath) {
    final keysToRemove = _svgCache.keys.where((key) => key.startsWith(assetPath)).toList();
    for (final key in keysToRemove) {
      _svgCache.remove(key);
    }
    _svgStringCache.remove(assetPath);
  }

  /// Obtiene el tamaño del cache
  int get cacheSize => _svgCache.length;

  /// Widget de error cuando falla la carga del SVG
  Widget _buildErrorWidget(String source, double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
      child: Icon(
        Icons.error_outline,
        color: Colors.grey[600],
        size: width != null ? width * 0.5 : 24,
      ),
    );
  }
}

/// Extension para facilitar el uso del SvgService
extension SvgServiceExtension on BuildContext {
  SvgService get svg => SvgService();
}
