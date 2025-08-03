import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/services/svg_service.dart';

/// Mapeo de nombres semánticos a rutas de archivos SVG
class SvgIcons {
  // Iconos de categorías de comida
  static const String sparkles = 'assets/svg/sparkles.svg';
  static const String label = 'assets/svg/label.svg';
  static const String gridAll = 'assets/svg/grid-all.svg';
  static const String coffeeBreakfast = 'assets/svg/coffe.svg';
  static const String dinner = 'assets/svg/dinner.svg';
  static const String drink = 'assets/svg/drink.svg';
  static const String foodDinner = 'assets/svg/food-dinner.svg';
  static const String friedChicken = 'assets/svg/fried-chicken.svg';
  static const String hamburger = 'assets/svg/hamburger.svg';
  static const String home = 'assets/svg/home.svg';
  static const String lunch = 'assets/svg/lunch.svg';
  static const String plan = 'assets/svg/plan.svg';
  static const String profile = 'assets/svg/profile.svg';
  static const String soup = 'assets/svg/soup.svg';
  static const String timerFast = 'assets/svg/timer_fast.svg';
  static const String vegetarian = 'assets/svg/vegetarian.svg';
  static const String cake = 'assets/svg/cake.svg';
  static const String analysis = 'assets/svg/analysis.svg';
  static const String microphone = 'assets/svg/microphone.svg';
  static const String image = 'assets/svg/image.svg';
  static const String search = 'assets/svg/search.svg';
  static const String close = 'assets/svg/close.svg';
  static const String user = 'assets/svg/user.svg';
  static const String email = 'assets/svg/email.svg';
  static const String lock = 'assets/svg/lock.svg';

  // Método para obtener la ruta por nombre
  static String? getPath(String name) {
    switch (name.toLowerCase()) {
      case 'sparkle':
        return sparkles;
      case 'label':
        return label;
      case 'gridall':
        return gridAll;
      case 'coffeebreakfast':
      case 'coffee_breakfast':
      case 'coffe':
        return coffeeBreakfast;
      case 'dinner':
        return dinner;
      case 'drink':
        return drink;
      case 'fooddinner':
      case 'food_dinner':
        return foodDinner;
      case 'friedchicken':
      case 'fried_chicken':
        return friedChicken;
      case 'hamburger':
        return hamburger;
      case 'home':
        return home;
      case 'lunch':
        return lunch;
      case 'plan':
        return plan;
      case 'profile':
        return profile;
      case 'soup':
        return soup;
      case 'timerfast':
      case 'timer_fast':
        return timerFast;
      case 'vegetarian':
        return vegetarian;
      case 'cake':
        return cake;
      case 'analysis':
        return analysis;
      case 'microphone':
        return microphone;
      case 'image':
        return image;
      case 'search':
        return search;
      case 'close':
        return close;
      case 'user':
        return user;
      case 'email':
        return email;
      case 'lock':
        return lock;
      default:
        return null;
    }
  }
}

/// Widget personalizado para mostrar SVGs con gestión automática de cache
class AppSvg extends StatefulWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppSvg({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.color,
    this.fit = BoxFit.contain,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<AppSvg> createState() => _AppSvgState();
}

class _AppSvgState extends State<AppSvg> {
  Widget? _svgWidget;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadSvg();
  }

  @override
  void didUpdateWidget(AppSvg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath ||
        oldWidget.color != widget.color ||
        oldWidget.width != widget.width ||
        oldWidget.height != widget.height ||
        oldWidget.fit != widget.fit) {
      _loadSvg();
    }
  }

  Future<void> _loadSvg() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final svgWidget = await context.svg.loadSvgFromAssets(
        widget.assetPath,
        width: widget.width,
        height: widget.height,
        color: widget.color,
        fit: widget.fit,
      );

      if (mounted) {
        setState(() {
          _svgWidget = svgWidget;
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
              Icons.error_outline,
              color: Colors.grey[600],
              size: widget.width != null ? widget.width! * 0.5 : 24,
            ),
          );
    }

    return _svgWidget ?? const SizedBox.shrink();
  }
}

/// Widget para SVG con icono (especialmente para etiquetas)
class AppSvgIcon extends StatelessWidget {
  final String assetPath;
  final double? size;
  final Color? color;
  final BoxFit fit;

  const AppSvgIcon({
    super.key,
    required this.assetPath,
    this.size,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return AppSvg(
      assetPath: assetPath,
      width: size,
      height: size,
      color: color,
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

/// Extension para facilitar el uso de SVGs
extension AppSvgExtension on BuildContext {
  AppSvgIcon svgIcon(String assetPath, {double? size, Color? color}) {
    return AppSvgIcon(assetPath: assetPath, size: size, color: color);
  }

  AppSvg svgImage(String assetPath, {double? width, double? height, Color? color}) {
    return AppSvg(assetPath: assetPath, width: width, height: height, color: color);
  }

  /// Extension semántica para íconos SVG usando nombres
  SvgIconSemantic get svgIconSemantic => SvgIconSemantic(this);
}

/// Clase para uso semántico de íconos SVG
class SvgIconSemantic {
  final BuildContext context;

  SvgIconSemantic(this.context);

  AppSvgIcon lock({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.lock, size: size, color: color);
  }

  AppSvgIcon email({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.email, size: size, color: color);
  }

  AppSvgIcon user({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.user, size: size, color: color);
  }

  AppSvgIcon close({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.close, size: size, color: color);
  }

  AppSvgIcon microphone({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.microphone, size: size, color: color);
  }

  AppSvgIcon image({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.image, size: size, color: color);
  }

  AppSvgIcon search({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.search, size: size, color: color);
  }

  AppSvgIcon sparkle({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.sparkles, size: size, color: color);
  }

  AppSvgIcon label({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.label, size: size, color: color);
  }

  AppSvgIcon gridAll({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.gridAll, size: size, color: color);
  }

  AppSvgIcon coffeeBreakfast({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.coffeeBreakfast, size: size, color: color);
  }

  AppSvgIcon dinner({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.dinner, size: size, color: color);
  }

  AppSvgIcon drink({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.drink, size: size, color: color);
  }

  AppSvgIcon foodDinner({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.foodDinner, size: size, color: color);
  }

  AppSvgIcon friedChicken({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.friedChicken, size: size, color: color);
  }

  AppSvgIcon hamburger({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.hamburger, size: size, color: color);
  }

  AppSvgIcon home({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.home, size: size, color: color);
  }

  AppSvgIcon lunch({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.lunch, size: size, color: color);
  }

  AppSvgIcon plan({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.plan, size: size, color: color);
  }

  AppSvgIcon profile({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.profile, size: size, color: color);
  }

  AppSvgIcon soup({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.soup, size: size, color: color);
  }

  AppSvgIcon timerFast({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.timerFast, size: size, color: color);
  }

  AppSvgIcon vegetarian({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.vegetarian, size: size, color: color);
  }

  AppSvgIcon cake({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.cake, size: size, color: color);
  }

  AppSvgIcon analysis({double? size, Color? color}) {
    return AppSvgIcon(assetPath: SvgIcons.analysis, size: size, color: color);
  }

  /// Método genérico para cualquier ícono por nombre
  AppSvgIcon? byName(String name, {double? size, Color? color}) {
    final path = SvgIcons.getPath(name);
    if (path != null) {
      return AppSvgIcon(assetPath: path, size: size, color: color);
    }
    return null;
    /**
     * ...([
                          {'name': 'sparkle', 'color': Colors.amber},
                          {'name': 'grid_all', 'color': Colors.blue},
                          {'name': 'coffee_breakfast', 'color': Colors.brown},
                        ]).map(
                          (icon) =>
                              context.svgIconSemantic.byName(
                                icon['name'] as String,
                                size: 24,
                                color: icon['color'] as Color?,
                              ) ??
                              Icon(Icons.error, size: 24, color: icon['color'] as Color?),
                        ),
     */
  }
}
