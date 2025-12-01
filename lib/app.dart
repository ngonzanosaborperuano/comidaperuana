import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/common/widget/platform_app_builder.dart';
import 'package:goncook/core/di/bloc_dependencies.dart';
import 'package:goncook/core/router/app_router.dart';

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
