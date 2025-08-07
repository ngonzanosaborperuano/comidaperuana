import 'package:recetasperuanas/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:recetasperuanas/domain/core/value_objects.dart';

class LogoutUseCase {
  const LogoutUseCase(this._authRepository);

  final IUserAuthRepository _authRepository;

  /// Execute user logout
  Future<Result<void, DomainException>> execute() async {
    return await _authRepository.signOut();
  }
}
