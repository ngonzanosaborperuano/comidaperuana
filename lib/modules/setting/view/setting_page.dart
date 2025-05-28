import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/network/api_service.dart';
import 'package:recetasperuanas/modules/setting/controller/setting_controller.dart';
import 'package:recetasperuanas/modules/setting/view/setting_view.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  factory SettingPage.routeBuilder(_, __) {
    return const SettingPage(key: Key('setting_page'));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingController>(
      create:
          (_) =>
              SettingController(userRepository: UserRepository(apiService: ApiService()))
                ..getUser(),
      child: const SettingView(),
    );
  }
}
