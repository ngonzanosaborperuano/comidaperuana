import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/network/api_service.dart';
import 'package:recetasperuanas/core/provider/locale_provider.dart';
import 'package:recetasperuanas/core/provider/theme_provider.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart';

List<SingleChildWidget> globalProviders(BuildContext context) {
  final apiService = ApiService();
  final userRepository = UserRepository(apiService: apiService);

  return [
    Provider<UserRepository>.value(value: userRepository),
    ChangeNotifierProvider(
      create: (_) => LoginController(userRepository: userRepository)..init(context),
    ),
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ];
}
