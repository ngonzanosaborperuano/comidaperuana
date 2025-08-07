import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:recetasperuanas/application/auth/use_cases/register_use_case.dart'
    show RegisterUseCase;
import 'package:recetasperuanas/core/auth/models/auth_user.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_repository.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class RegisterController extends BaseController {
  RegisterController({
    required RegisterUseCase registerUseCase,
    required IUserRepository userRepository,
  }) : _registerUseCase = registerUseCase,
       _userRepository = userRepository;
  @override
  String get name => 'RegisterController';

  final IUserRepository _userRepository;
  final RegisterUseCase _registerUseCase;

  final _logger = Logger('RegisterController');
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  ValueNotifier<bool> isObscureText = ValueNotifier<bool>(true);

  ValueNotifier<bool> isReObscureText = ValueNotifier<bool>(true);

  // State
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<AuthUser?> _currentUser = ValueNotifier<AuthUser?>(null);
  final ValueNotifier<String?> _errorMessage = ValueNotifier<String?>(null);
  // Getters
  ValueNotifier<bool> get isLoading => _isLoading;
  ValueNotifier<AuthUser?> get currentUser => _currentUser;
  ValueNotifier<String?> get errorMessage => _errorMessage;
  Future<bool> register(AuthUser user) async {
    _setLoading(true);
    _clearError();
    try {
      final result = await _registerUseCase.execute(
        email: emailController.text,
        password: passwordController.text,
        name: fullNameController.text,
      );

      if (result.isSuccess) {
        _currentUser.value = result.successValue;
        _userRepository.register(user);
        _showSuccess('Registro exitoso');
        return true;
      } else {
        _setError(result.failureValue!.message);
        return false;
      }
    } catch (e, stackTrace) {
      _logger.severe('Error al registrar: $e', e, stackTrace);
      addError(e, stackTrace);
      return false;
    }
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
}
