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
  ValueNotifier<bool> isObscureText = ValueNotifier<bool>(true);

  Future<(bool, String)> login({required AuthUser user, required int type}) async {
    try {
      final (result, msg) = await _userRepository.login(user: user, type: type);
      _logger.info('Resultado de inicio de sesión: $result');
      if (result == false) {
        return (false, msg);
      }
      passwordController.clear();
      emailController.clear();
      return (true, msg);
    } catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión: $e', e, stackTrace);
      return (false, 'Error al iniciar sesión: $e');
    }
  }

  Future<String?> recoverCredential(String email) async {
    return await _userRepository.recoverCredential(email);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
