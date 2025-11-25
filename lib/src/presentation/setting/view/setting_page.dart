import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/src/application/use_cases/logout_use_case.dart';
import 'package:goncook/src/domain/auth/repositories/i_user_repository.dart';
import 'package:goncook/src/presentation/setting/bloc/setting_bloc.dart';
import 'package:goncook/src/presentation/setting/di/setting_dependencies.dart';
import 'package:goncook/src/presentation/setting/view/setting_view.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  factory SettingPage.routeBuilder(_, _) {
    return const SettingPage(key: Key('setting_page'));
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: settingModuleProviders(context),
      child: BlocProvider<SettingBloc>(
        create: (context) => SettingBloc(
          userRepository: context.read<IUserRepository>(),
          logoutUseCase: context.read<LogoutUseCase>(),
        )..add(SettingLoadRequested()),
        child: const SettingView(),
      ),
    );
  }
}
