import 'package:goncook/src/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:goncook/src/shared/shared.dart' show AppResult;

class LogoutUseCase {
  const LogoutUseCase(this._authRepository);

  final IUserAuthRepository _authRepository;

  /// Execute user logout
  Future<AppResult<void>> execute() async {
    return await _authRepository.signOut();
  }
}
