import 'package:recetasperuanas/core/auth/models/auth_user.dart' show AuthUser;
import 'package:recetasperuanas/core/constants/option.dart' show LoginWith;
import 'package:recetasperuanas/domain/auth/entities/user.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:recetasperuanas/domain/auth/value_objects/email.dart';
import 'package:recetasperuanas/domain/core/value_objects.dart';

class LoginUseCase {
  const LoginUseCase(this._authRepository);

  final IUserAuthRepository _authRepository;

  /// Execute login with email and password
  Future<Result<AuthUser, DomainException>> execute({
    required String email,
    required String password,
    required int type,
  }) async {
    if (type == LoginWith.withGoogle) {
      return await _authRepository.authenticateGoogle();
    } else if (type == LoginWith.withUserPassword) {
      final emailResult = Email.create(email);
      if (emailResult.isFailure) {
        return Failure(emailResult.failureValue!);
      }
      if (password.isEmpty) {
        return const Failure(ValidationException('La contraseña no puede estar vacía'));
      }
      return await _authRepository.authenticateEmail(emailResult.successValue!, password);
    }
    return const Failure(ValidationException('Tipo de inicio de sesión no soportado'));
  }

  /// Execute recover credential
  Future<Result<String, DomainException>> executeRecoverCredential(String email) async {
    return await _authRepository.recoverCredential(email);
  }
}

/// Use case for getting current user
class GetCurrentUserUseCase {
  const GetCurrentUserUseCase(this._authRepository);

  final IUserAuthRepository _authRepository;

  /// Execute get current user
  Future<Result<User?, DomainException>> execute() async {
    return await _authRepository.getCurrentUser();
  }
}
