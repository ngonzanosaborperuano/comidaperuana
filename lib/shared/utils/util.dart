import 'package:flutter/material.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/widget/widget.dart';

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
                      color: backgroundColor,
                      spreadRadius: 1,
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

Future<void> showCustomDialog({
  required BuildContext context,
  required String title,
  required String description,
  String? acceptText,
  VoidCallback? onAccept,
  required Color backgroundColor,
  required Color foregroundColor,
}) {
  return showAdaptiveDialog(
    context: context,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: backgroundColor,
          ),
          padding: const EdgeInsets.all(20),
          width: MediaQuery.sizeOf(context).width * 0.9,
          height: MediaQuery.sizeOf(context).height * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: foregroundColor,
                ),
              ),
              Text(
                description,
                style: TextStyle(fontSize: 16, color: foregroundColor),
                textAlign: TextAlign.center,
              ),
              AppButton(
                text: acceptText ?? context.loc.accept,
                onPressed: onAccept,
              ),
            ],
          ),
        ),
      );
    },
  );
}
