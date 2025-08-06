import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:recetasperuanas/core/auth/models/auth_user.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/result/app_result.dart';
import 'package:recetasperuanas/core/secure_storage/securete_storage_service.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class LoginControllerOld extends BaseController {
  LoginControllerOld({required UserRepository userRepository}) : _userRepository = userRepository {
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
      // Use the new Result pattern internally
      final result = await _executeLogin(user, type);

      if (result.isSuccess) {
        passwordController.clear();
        emailController.clear();
        return (true, result.valueOrNull ?? 'Login exitoso');
      } else {
        return (false, result.errorMessage ?? 'Error en el login');
      }
    } catch (e, stackTrace) {
      _logger.severe('Error al iniciar sesión: $e', e, stackTrace);
      return (false, 'Error al iniciar sesión: $e');
    }
  }

  /// Internal method using Result pattern
  Future<AppResult<String>> _executeLogin(AuthUser user, int type) async {
    try {
      final (result, msg) = await _userRepository.login(user: user, type: type);
      _logger.info('Resultado de inicio de sesión: $result');

      if (result == false) {
        return AppResult.failure(msg);
      }

      return AppResult.success(msg);
    } catch (e) {
      return AppResult.failure('Error al iniciar sesión: $e');
    }
  }

  Future<String?> recoverCredential(String email) async {
    return await _userRepository.recoverCredential(email);
  }

  /// New method using Result pattern for better error handling
  Future<AppResult<String>> recoverCredentialWithResult(String email) async {
    try {
      final result = await _userRepository.recoverCredential(email);
      if (result != null) {
        return AppResult.success(result);
      } else {
        return const AppResult.failure('No se pudo recuperar la credencial');
      }
    } catch (e) {
      return AppResult.failure('Error al recuperar credencial: $e');
    }
  }

  /// New method for Google login using Result pattern
  Future<AppResult<String>> loginWithGoogle() async {
    try {
      // TODO: Implement Google login with Result pattern
      return const AppResult.failure('Google login not implemented yet');
    } catch (e) {
      return AppResult.failure('Error en Google login: $e');
    }
  }

  /// New method for logout using Result pattern
  Future<AppResult<void>> logout() async {
    try {
      // TODO: Implement logout with Result pattern
      return const AppResult.success(null);
    } catch (e) {
      return AppResult.failure('Error en logout: $e');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
