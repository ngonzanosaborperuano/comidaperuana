import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/secure_storage/securete_storage_service.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class LoginController extends BaseController {
  LoginController({required UserRepository userRepository}) : _userRepository = userRepository {
    _logger.info('LoginController initialized');
  }

  @override
  String get name => 'LoginController';

  final UserRepository _userRepository;

  final _logger = Logger('LoginController');
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ISecureStorageService secureStorageService = SecurityStorageService();

  Future<bool?> login({required AuthUser user, required int type}) async {
    try {
      final result = await _userRepository.login(user: user, type: type);
      _logger.info('Resultado de inicio de sesión: $result');
      if (result == null || result == false) {
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
