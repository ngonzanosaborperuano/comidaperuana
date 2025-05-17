import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:recetasperuanas/core/config/color/app_color_scheme.dart';

class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppSwitch({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColorScheme.of(context).success,
      );
    } else {
      return Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColorScheme.of(context).success,
      );
    }
  }
}
