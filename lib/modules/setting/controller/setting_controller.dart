import 'package:flutter/cupertino.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/secure_storage/securete_storage_service.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/models/user_model.dart';
import 'package:logging/logging.dart';

class SettingController extends BaseController {
  SettingController({required UserRepository userRepository})
    : _userRepository = userRepository {
    _logger.info('SettingController initialized');
  }

  @override
  String get name => 'SettingController';

  final UserRepository _userRepository;

  final _logger = Logger('LoginController');

  UserModel userModel = UserModel.empty;

  final isSpanish = ValueNotifier<bool>(false);
  final isDark = ValueNotifier<bool>(false);

  ISecureStorageService secureStorageService = SecurityStorageService();

  Future<void> getUser() async {
    userModel = await _userRepository.getUser();
    notifyListeners();
  }

  Future<void> logout() async {
    await secureStorageService.deleteCredentials();
  }
}
