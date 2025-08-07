import 'package:flutter/material.dart';
import 'package:recetasperuanas/application/auth/use_cases/login_use_case.dart';
import 'package:recetasperuanas/application/auth/use_cases/logout_use_case.dart' show LogoutUseCase;
import 'package:recetasperuanas/application/auth/use_cases/register_use_case.dart'
    show RegisterUseCase;
import 'package:recetasperuanas/core/auth/models/auth_user.dart' show AuthUser;
import 'package:recetasperuanas/domain/auth/repositories/i_user_repository.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

/// Enhanced login controller using DDD architecture
class LoginController extends BaseController {
  LoginController({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required IUserRepository userRepository,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _userRepository = userRepository;

  @override
  String get name => 'LoginController';

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final IUserRepository _userRepository;

  // State
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<AuthUser?> _currentUser = ValueNotifier<AuthUser?>(null);
  final ValueNotifier<String?> _errorMessage = ValueNotifier<String?>(null);

  // Getters
  ValueNotifier<bool> get isLoading => _isLoading;
  ValueNotifier<AuthUser?> get currentUser => _currentUser;
  ValueNotifier<String?> get errorMessage => _errorMessage;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  /// Login with email and password
  Future<(bool, String)> login({
    required String email,
    required String password,
    required int type,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _loginUseCase.execute(email: email, password: password, type: type);

      if (result.isSuccess) {
        _currentUser.value = result.successValue;
        final (isSuccess, msg) = await _userRepository.signInOrRegister(result.successValue!);
        if (isSuccess) {
          _showSuccess('Inicio de sesión exitoso');
        } else {
          _setError(msg);
        }
        return (isSuccess, msg);
      } else {
        _setError(result.failureValue!.message);
        return (false, result.failureValue!.message);
      }
    } catch (e) {
      _setError('Error inesperado: $e');
      return (false, 'Error inesperado: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Register new user
  Future<void> register({required String email, required String password, String? name}) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _registerUseCase.execute(email: email, password: password, name: name);

      if (result.isSuccess) {
        _currentUser.value = result.successValue;
        _showSuccess('Registro exitoso');
      } else {
        _setError(result.failureValue!.message);
      }
    } catch (e) {
      _setError('Error inesperado: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Logout current user
  Future<void> logout() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _logoutUseCase.execute();

      if (result.isSuccess) {
        _currentUser.value = null;
        _showSuccess('Sesión cerrada exitosamente');
      } else {
        _setError(result.failureValue!.message);
      }
    } catch (e) {
      _setError('Error inesperado: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> recoverCredential(String email) async {
    final result = await _loginUseCase.executeRecoverCredential(email);
    if (result.isSuccess) {
      _showSuccess('Correo de recuperación enviado');
      return result.successValue;
    } else {
      _setError(result.failureValue!.message);
      return result.failureValue!.message;
    }
  }

  /// Validate email format
  @override
  String? validateEmail(String email, BuildContext context) {
    if (email.isEmpty) {
      return 'El email no puede estar vacío';
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return 'El formato del email no es válido';
    }

    return null;
  }

  /// Validate password strength
  @override
  String? validatePassword(String? password, BuildContext context) {
    if (password == null || password.isEmpty) {
      return 'La contraseña no puede estar vacía';
    }

    if (password.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    if (!RegExp(r'^(?=.*[A-Z])').hasMatch(password)) {
      return 'La contraseña debe contener al menos una mayúscula';
    }

    if (!RegExp(r'^(?=.*[a-z])').hasMatch(password)) {
      return 'La contraseña debe contener al menos una minúscula';
    }

    if (!RegExp(r'^(?=.*\d)').hasMatch(password)) {
      return 'La contraseña debe contener al menos un número';
    }

    return null;
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading.value = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage.value = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage.value = null;
    notifyListeners();
  }

  void _showSuccess(String message) {
    logger.info(message);
  }

  @override
  void dispose() {
    _isLoading.dispose();
    _currentUser.dispose();
    _errorMessage.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
