import 'package:flutter/material.dart';
import 'package:goncook/common/extension/extension.dart';
import 'package:goncook/common/widget/widget.dart' show AppHorizontalSpace, AppVerticalSpace;

enum ToastType { success, error, warning, info }

class AppToast {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;

  static void show({
    required BuildContext context,
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    String? title,
  }) {
    if (_isVisible) return;

    _isVisible = true;
    _overlayEntry = _createOverlay(context, message, type, duration, title);
    Overlay.of(context).insert(_overlayEntry!);

    Future.delayed(duration, () {
      hide();
    });
  }

  static void hide() {
    if (_overlayEntry != null && _isVisible) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isVisible = false;
    }
  }

  static OverlayEntry _createOverlay(
    BuildContext context,
    String message,
    ToastType type,
    Duration duration,
    String? title,
  ) {
    return OverlayEntry(
      builder: (context) => _ToastWidget(message: message, type: type, title: title),
    );
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final ToastType type;
  final String? title;

  const _ToastWidget({required this.message, required this.type, this.title});

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeInBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut, reverseCurve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeInBack,
      ),
    );

    _controller.forward();

    // Auto hide animation
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBackgroundColor(BuildContext context) {
    final color = context.color;
    switch (widget.type) {
      case ToastType.success:
        return color.successBackground;
      case ToastType.error:
        return color.errorBackground;
      case ToastType.warning:
        return color.warningBackground;
      case ToastType.info:
        return color.surface;
    }
  }

  Color _getTextColor(BuildContext context) {
    final color = context.color;
    switch (widget.type) {
      case ToastType.success:
        return color.success;
      case ToastType.error:
        return color.errorText;
      case ToastType.warning:
        return color.warning;
      case ToastType.info:
        return color.text;
    }
  }

  Color _getIconColor(BuildContext context) {
    final color = context.color;
    switch (widget.type) {
      case ToastType.success:
        return color.success;
      case ToastType.error:
        return color.errorText;
      case ToastType.warning:
        return color.warning;
      case ToastType.info:
        return color.info;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle_outline;
      case ToastType.error:
        return Icons.error_outline;
      case ToastType.warning:
        return Icons.warning_amber_outlined;
      case ToastType.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _getBackgroundColor(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getIconColor(context).withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.color.shadow,
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: _getIconColor(context).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_getIcon(), color: _getIconColor(context), size: 20),
                    ),
                    AppHorizontalSpace.sl,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.title != null) ...[
                            Text(
                              widget.title!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _getTextColor(context),
                              ),
                            ),
                            AppVerticalSpace.xxs,
                          ],
                          Text(
                            widget.message,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _getTextColor(context).withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _controller.reverse().then((_) {
                          AppToast.hide();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close,
                          color: _getTextColor(context).withValues(alpha: 0.6),
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Extension para facilitar el uso
extension AppToastExtension on BuildContext {
  void showToast({
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    String? title,
  }) {
    AppToast.show(context: this, message: message, type: type, duration: duration, title: title);
  }

  void showSuccessToast(String message, {String? title}) {
    showToast(message: message, type: ToastType.success, title: title);
  }

  void showErrorToast(String message, {String? title}) {
    showToast(message: message, type: ToastType.error, title: title);
  }

  void showWarningToast(String message, {String? title}) {
    showToast(message: message, type: ToastType.warning, title: title);
  }

  void showInfoToast(String message, {String? title}) {
    showToast(message: message, type: ToastType.info, title: title);
  }
}
