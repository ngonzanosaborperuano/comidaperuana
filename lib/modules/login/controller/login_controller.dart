import 'package:flutter/widgets.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/secure_storage/securete_storage_service.dart';

import 'package:recetasperuanas/shared/controller/base_controller.dart';

import 'package:logging/logging.dart';

class LoginController extends BaseController {
  LoginController({required UserRepository userRepository})
    : _userRepository = userRepository {
    _logger.info('LoginController initialized');
  }

  @override
  String get name => 'LoginController';

  final UserRepository _userRepository;

  final _logger = Logger('LoginController');
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ISecureStorageService secureStorageService = SecurityStorageService();

  Future<bool?> login(AuthUser user) async {
    try {
      // final userData = await secureStorageService.loadCredentials();
      // if (userData?.id == null) {
      //   return false;
      // }
      final result = await _userRepository.login(user);
      _logger.info('Resultado de inicio de sesión: $result');
      if (result == null || result == false) {
        _logger.info('Error al iniciar sesión');
        return false;
      }
      passwordController.clear();
      emailController.clear();
      return true;
    } catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión: $e', e, stackTrace);
      addError(e, stackTrace);
      return null;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
