import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/config/color/app_colors.dart';
import 'package:recetasperuanas/shared/widget/text_widget.dart';

void showCustomSnackBar({
  required BuildContext context,
  required String message,
  required Color backgroundColor,
  required Color foregroundColor,
}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder:
        (context) => Positioned(
          top: kToolbarHeight + 25,
          right: 10,
          child: Material(
            color: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success,
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: AppText(text: message, color: foregroundColor),
              ),
            ),
          ),
        ),
  );

  // Mostrar el SnackBar personalizado
  overlay.insert(overlayEntry);

  // Eliminar después de 3 segundos
  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}
