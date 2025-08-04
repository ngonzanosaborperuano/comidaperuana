import 'package:flutter/material.dart';
import 'package:recetasperuanas/application/auth/use_cases/login_use_case.dart';
import 'package:recetasperuanas/core/constants/option.dart';
import 'package:recetasperuanas/domain/auth/entities/user.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

/// Enhanced login controller using DDD architecture
class LoginController extends BaseController {
  LoginController({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase;

  @override
  String get name => 'LoginController';

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;

  // State
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<User?> _currentUser = ValueNotifier<User?>(null);
  final ValueNotifier<String?> _errorMessage = ValueNotifier<String?>(null);

  // Getters
  ValueNotifier<bool> get isLoading => _isLoading;
  ValueNotifier<User?> get currentUser => _currentUser;
  ValueNotifier<String?> get errorMessage => _errorMessage;

  /// Login with email and password
  Future<void> login({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _loginUseCase.execute(email: email, password: password);

      if (result.isSuccess) {
        _currentUser.value = result.successValue;
        _showSuccess('Inicio de sesión exitoso');
      } else {
        _setError(result.failureValue!.message);
      }
    } catch (e) {
      _setError('Error inesperado: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Login method for backward compatibility with existing view
  Future<(bool success, String message)> loginWithUser({
    required Map<String, dynamic> user,
    required LoginWith type,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final email = user['email'] as String;
      final password = user['password'] as String;

      final result = await _loginUseCase.execute(email: email, password: password);

      if (result.isSuccess) {
        _currentUser.value = result.successValue;
        _showSuccess('Inicio de sesión exitoso');
        return (true, 'Inicio de sesión exitoso');
      } else {
        final errorMessage = result.failureValue!.message;
        _setError(errorMessage);
        return (false, errorMessage);
      }
    } catch (e) {
      final errorMessage = 'Error inesperado: $e';
      _setError(errorMessage);
      return (false, errorMessage);
    } finally {
      _setLoading(false);
    }
  }

  /// Login with Google
  Future<void> loginWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _loginUseCase.executeWithGoogle();

      if (result.isSuccess) {
        _currentUser.value = result.successValue;
        _showSuccess('Inicio de sesión con Google exitoso');
      } else {
        _setError(result.failureValue!.message);
      }
    } catch (e) {
      _setError('Error inesperado: $e');
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
    // This would typically show a success toast
    logger.info(message);
  }

  @override
  void dispose() {
    _isLoading.dispose();
    _currentUser.dispose();
    _errorMessage.dispose();
    super.dispose();
  }
}
