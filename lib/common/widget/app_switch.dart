import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goncook/common/extension/extension.dart';

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
        activeTrackColor: context.color.buttonPrimary,
      );
    } else {
      return Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: context.color.buttonPrimary,
      );
    }
  }
}
