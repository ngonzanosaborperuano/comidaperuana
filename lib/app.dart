import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/di/dependencies.dart';
import 'package:recetasperuanas/core/router/app_router.dart';
import 'package:recetasperuanas/shared/widget/platform_app_builder.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: globalProviders(context),
      child: PlatformAppBuilder(appRouter: appRouter),
    );
  }
}
