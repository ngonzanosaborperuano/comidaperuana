import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider, MultiProvider, ReadContext;
import 'package:recetasperuanas/application/auth/use_cases/logout_use_case.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_repository.dart';
import 'package:recetasperuanas/modules/setting/controller/setting_controller.dart';
import 'package:recetasperuanas/modules/setting/di/setting_dependencies.dart';
import 'package:recetasperuanas/modules/setting/view/setting_view.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  factory SettingPage.routeBuilder(_, _) {
    return const SettingPage(key: Key('setting_page'));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...settingModuleProviders(context),
        ChangeNotifierProvider(
          create:
              (context) => SettingController(
                userRepository: context.read<IUserRepository>(),
                logoutUseCase: context.read<LogoutUseCase>(),
              )..getUser(),
        ),
      ],
      child: const SettingView(),
    );
  }
}
