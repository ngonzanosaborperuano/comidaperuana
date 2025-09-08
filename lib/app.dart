import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recetasperuanas/src/presentation/core/router/app_router.dart';
import 'package:recetasperuanas/src/shared/core/di/bloc_dependencies.dart';
import 'package:recetasperuanas/src/shared/widget/platform_app_builder.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: globalRepositoryProviders(context),
      child: MultiBlocProvider(
        providers: globalBlocProviders(context),
        child: PlatformAppBuilder(appRouter: appRouter),
      ),
    );
  }
}
