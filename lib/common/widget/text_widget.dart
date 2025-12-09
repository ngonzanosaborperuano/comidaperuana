import 'package:flutter/material.dart';
import 'package:goncook/core/extension/extension.dart';

class AppText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  const AppText({
    super.key,
    required this.text,
    this.fontSize = 18,
    this.fontWeight,
    this.color,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 5,
      style: TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: context.color.text),
      textAlign: textAlign,
    );
  }
}
