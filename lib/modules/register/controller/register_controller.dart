import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:recetasperuanas/core/auth/model/auth_user.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';

class RegisterController extends BaseController {
  RegisterController({required UserRepository userRepository}) : _userRepository = userRepository;
  @override
  String get name => 'RegisterController';

  final UserRepository _userRepository;

  final _logger = Logger('RegisterController');
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  ValueNotifier<bool> isObscureText = ValueNotifier<bool>(true);

  ValueNotifier<bool> isReObscureText = ValueNotifier<bool>(true);

  Future<bool?> register(AuthUser user) async {
    try {
      final result = await _userRepository.register(user);
      _logger.info('Resultado del registro: $result');
      if (result == false) {
        _logger.info('Error al registrar');
        return false;
      }
      return true;
    } catch (e, stackTrace) {
      _logger.severe('Error al registrar: $e', e, stackTrace);
      addError(e, stackTrace);
      return null;
    }
  }
}
