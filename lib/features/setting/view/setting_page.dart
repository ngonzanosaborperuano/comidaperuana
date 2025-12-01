import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goncook/features/auth/domain/repositories/user_repository.dart';
import 'package:goncook/features/auth/domain/usecases/logout_usecase.dart';
import 'package:goncook/features/setting/bloc/setting_bloc.dart';
import 'package:goncook/features/setting/di/setting_dependencies.dart';
import 'package:goncook/features/setting/view/setting_view.dart';
import 'package:goncook/services/network/network.dart';

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
          userRepository: UserRepository(apiService: context.read<ApiService>()),
          logoutUseCase: context.read<LogoutUseCase>(),
        )..add(SettingLoadRequested()),
        child: const SettingView(),
      ),
    );
  }
}
