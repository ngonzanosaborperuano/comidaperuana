import 'package:goncook/common/constants/option.dart' show LoginWith;
import 'package:goncook/common/shared.dart' show AppResult;
import 'package:goncook/features/auth/data/models/auth_user.dart' show AuthUser;
import 'package:goncook/features/auth/domain/auth/entities/user.dart';
import 'package:goncook/features/auth/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:goncook/features/auth/domain/auth/value_objects/email.dart';

class LoginUseCase {
  const LoginUseCase(this._authRepository);

  final IUserAuthRepository _authRepository;

  /// Execute login with email and password
  Future<AppResult<AuthUser>> execute({
    required String email,
    required String password,
    required int type,
  }) async {
    if (type == LoginWith.withGoogle) {
      return await _authRepository.authenticateGoogle();
    } else if (type == LoginWith.withUserPassword) {
      final emailResult = Email.create(email);
      if (emailResult.isFailure) {
        return AppResult.failure(emailResult.errorMessage!);
      }
      if (password.isEmpty) {
        return const AppResult.failure('La contraseña no puede estar vacía');
      }
      return await _authRepository.authenticateEmail(emailResult.valueOrNull!, password);
    }
    return const AppResult.failure('Tipo de inicio de sesión no soportado');
  }

  /// Execute recover credential
  Future<AppResult<String>> executeRecoverCredential(String email) async {
    return await _authRepository.recoverCredential(email);
  }
}

/// Use case for getting current user
class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._authRepository);

  final IUserAuthRepository _authRepository;

  /// Execute get current user
  Future<AppResult<User?>> execute() async {
    return await _authRepository.getCurrentUser();
  }
}
