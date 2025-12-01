import 'package:goncook/common/shared.dart' show AppResultService;
import 'package:goncook/features/auth/domain/auth/repositories/i_user_auth_repository.dart';

class LogoutUseCase {
  const LogoutUseCase(this._authRepository);

  final IUserAuthRepository _authRepository;

  /// Execute user logout
  Future<AppResultService<void>> execute() async {
    return await _authRepository.signOut();
  }
}
