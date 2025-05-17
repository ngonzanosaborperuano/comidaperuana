import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';

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
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoSearchTextField(
          onChanged: onChanged,
          controller: textController,
          placeholder: placeholder,
          placeholderStyle: const TextStyle(fontSize: 16),
          style: const TextStyle(fontSize: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: AppColorScheme.of(context).textSecundary,
          ),
        )
        : SizedBox(
          height: 65,
          child: TextField(
            cursorWidth: 2,
            onChanged: onChanged,
            controller: textController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffix: IconButton(
                onPressed: onPressed,
                icon: const Icon(Icons.close, size: 18),
              ),
              hintText: placeholder,
              hintStyle: TextStyle(fontSize: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  width: 2.0,
                  color: AppColorScheme.of(context).textSecundary,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  width: 2.0,
                  color: AppColorScheme.of(context).textSecundary,
                ),
              ),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        );
  }
}
