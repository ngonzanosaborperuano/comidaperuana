import 'package:goncook/common/shared.dart' show AppResultService;
import 'package:goncook/core/constants/option.dart' show LoginWith;
import 'package:goncook/core/generics/value_objects/email.dart';
import 'package:goncook/features/auth/data/models/auth_model.dart' show AuthModel;
import 'package:goncook/features/auth/data/models/user_model.dart';
import 'package:goncook/features/auth/domain/repositories/i_user_auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._authRepository);

  final IUserAuthRepository _authRepository;

  /// Execute login with email and password
  Future<AppResultService<AuthModel>> execute({
    required String email,
    required String password,
    required int type,
  }) async {
    if (type == LoginWith.withGoogle) {
      return await _authRepository.authenticateGoogle();
    } else if (type == LoginWith.withUserPassword) {
      final emailResult = Email.create(email);
      if (emailResult.isFailure) {
        return AppResultService.failure(emailResult.errorMessage!);
      }
      if (password.isEmpty) {
        return const AppResultService.failure('La contraseña no puede estar vacía');
      }
      return await _authRepository.authenticateEmail(emailResult.valueOrNull!, password);
    }
    return const AppResultService.failure('Tipo de inicio de sesión no soportado');
  }

  /// Execute recover credential
  Future<AppResultService<String>> executeRecoverCredential(String email) async {
    return await _authRepository.recoverCredential(email);
  }
}

/// Use case for getting current user
class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._authRepository);

  final IUserAuthRepository _authRepository;

  /// Execute get current user
  Future<AppResultService<UserModel?>> execute() async {
    return await _authRepository.getCurrentUser();
  }
}
