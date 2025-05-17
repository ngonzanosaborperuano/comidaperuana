import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/config/config.dart';
import 'package:go_router/go_router.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  Future<T> show<T>(
    BuildContext context, {
    required Future<T> Function() future,
  }) async {
    try {
      unawaited(
        showAdaptiveDialog(
          barrierColor: AppColors.transparent,
          barrierLabel: 'Cargando',
          context: context,
          builder: build,
          routeSettings: const RouteSettings(name: '/loadingDialog'),
        ),
      );
      return await future();
    } finally {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? const SizedBox(
          width: 20,
          height: 20,
          child: Center(child: RefreshProgressIndicator()),
        )
        : const CupertinoActivityIndicator(radius: 20);
  }
}
