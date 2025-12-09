import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goncook/common/widget/widget.dart';
import 'package:goncook/core/config/color/app_colors.dart';
import 'package:goncook/core/extension/extension.dart';

class AppTextFieldSearch extends StatelessWidget {
  final String placeholder;
  final TextEditingController textController;
  final Function(String) onChanged;
  final Function()? onPressed;

  const AppTextFieldSearch({
    super.key,
    required this.placeholder,
    required this.textController,
    required this.onChanged,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final prefixIcon = context.svgIcon(
      SvgIcons.search,
      color: context.color.textSecondary,
      size: 20,
    );
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoSearchTextField(
            prefixIcon: prefixIcon,
            suffixIcon: Icon(Icons.close, size: 15, color: context.color.textSecondary),
            onChanged: onChanged,
            controller: textController,
            placeholder: placeholder,
            placeholderStyle: const TextStyle(fontSize: 14, color: AppColors.slate400),
            style: const TextStyle(fontSize: 18),
            cursorColor: context.color.menuActive,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.transparent,
              border: Border.all(width: 0.1, color: AppColors.transparent),
            ),
          )
        : SizedBox(
            height: 55,
            child: TextField(
              cursorColor: context.color.buttonPrimary,
              onChanged: onChanged,
              controller: textController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.transparent,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: context.svgIcon(
                    SvgIcons.search,
                    color: context.color.textSecondary,
                    size: 15,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: onPressed,
                  icon: Icon(Icons.close, color: context.color.textSecondary),
                ),
                hintText: placeholder,
                hintStyle: const TextStyle(fontSize: 14, color: AppColors.slate400),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(width: 2.0, color: AppColors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(width: 0.1, color: AppColors.transparent),
                ),
              ),
              style: TextStyle(fontSize: 16, color: context.color.text),
            ),
          );
  }
}
