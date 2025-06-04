import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recetasperuanas/shared/widget/app_cupertino.dart';
import 'package:recetasperuanas/shared/widget/app_material.dart';

class PlatformAppBuilder extends StatelessWidget {
  final GoRouter appRouter;

  const PlatformAppBuilder({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.iOS
        ? AppCupertino(appRouter: appRouter)
        : AppMaterial(appRouter: appRouter);
  }
}
