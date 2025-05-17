import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return const CupertinoActivityIndicator(radius: 20.0);
    } else {
      return const CircularProgressIndicator(strokeWidth: 3.0);
    }
  }
}
