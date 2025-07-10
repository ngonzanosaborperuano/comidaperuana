import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';
import 'package:recetasperuanas/shared/widget/spacing/app_spacer.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.body,
    this.buttonsInRow = true,
    this.buttons,
    this.onClose,
    this.image,
    this.maxHeight,
    this.title,
    this.titleColor,
    this.closeable = true,
    super.key,
    this.backgroundColor,
  });

  final String? title;
  final Color? titleColor;
  final bool buttonsInRow;
  final Widget body;
  final Widget? image;
  final double? maxHeight;
  final List<Widget?>? buttons;
  final void Function()? onClose;
  final bool closeable;
  final Color? backgroundColor;

  Future<bool?> show(BuildContext context) async {
    return showAdaptiveDialog<bool>(context: context, builder: build);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      surfaceTintColor: AppColorScheme.of(context).text,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(minHeight: maxHeight ?? 220, maxWidth: 360),
        child: Stack(
          children: [
            if (closeable && onClose != null)
              Positioned(
                right: 4,
                top: 4,
                width: 40,
                height: 40,
                child: IconButton(
                  onPressed: onClose,
                  icon: Icon(Icons.close, size: 25, color: AppColorScheme.of(context).text),
                ),
              ),
            Container(
              constraints: BoxConstraints(maxHeight: maxHeight ?? 450),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (image != null) SizedBox(height: 120, child: image),
                    const SizedBox(height: 12),
                    if (title != null)
                      Text(
                        title!,
                        textAlign: TextAlign.center,
                        style:
                            titleColor != null
                                ? TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: titleColor,
                                )
                                : const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    Container(padding: const EdgeInsets.symmetric(vertical: 20), child: body),
                    if (buttons != null)
                      buttonsInRow
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (buttons!.firstOrNull != null) Expanded(child: buttons!.first!),
                              if (buttons!.length > 1) ...[
                                const SizedBox(width: 12),
                                Expanded(child: buttons![1]!),
                              ],
                            ],
                          )
                          : Column(children: [buttons!.first!, AppVerticalSpace.sl, buttons![1]!]),
                    AppVerticalSpace.md,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
