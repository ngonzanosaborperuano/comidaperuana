import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:goncook/common/widget/widget.dart';

extension LoadingExtension on BuildContext {
  Future<void> showLoading() async {
    await showAdaptiveDialog(
      context: this,
      builder: (context) => Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: const LoadingWidget(),
        ),
      ),
    );
  }

  void hideLoading() {
    Navigator.of(this).pop();
  }
}
