import 'package:flutter/cupertino.dart';
import 'package:logging/logging.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class SettingController extends BaseController {
  SettingController({required UserRepository userRepository}) : _userRepository = userRepository {
    _logger.info('SettingController initialized');
  }

  @override
  String get name => 'SettingController';

  final UserRepository _userRepository;

  final _logger = Logger('LoginController');

  AuthUser userModel = AuthUser.empty();

  final isSpanish = ValueNotifier<bool>(false);
  final isDark = ValueNotifier<bool>(false);

  Future<void> getUser() async {
    userModel = await _userRepository.getUser();
    notifyListeners();
  }

  Future<void> logout() async {
    await _userRepository.logout();
  }
}
