import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

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
          cursorColor: context.color.menuActive,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: context.color.textSecundary,
            border: Border.all(width: 2.0, color: context.color.menuIsNotActive),
          ),
        )
        : SizedBox(
          height: 50,
          child: TextField(
            onChanged: onChanged,
            controller: textController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: context.color.menuIsNotActive),
              suffix: IconButton(onPressed: onPressed, icon: const Icon(Icons.close, size: 15)),
              hintText: placeholder,
              hintStyle: TextStyle(fontSize: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(width: 2.0, color: context.color.menuIsNotActive),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(width: 2.0, color: context.color.menuIsNotActive),
              ),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        );
  }
}
