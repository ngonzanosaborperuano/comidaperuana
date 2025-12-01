import 'package:goncook/common/shared.dart' show AppResultService;
import 'package:goncook/features/auth/data/models/auth_user.dart' show AuthUser;
import 'package:goncook/features/auth/domain/auth/entities/user.dart';
import 'package:goncook/features/auth/domain/auth/repositories/i_user_auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._authRepository);

  final IUserAuthRepository _authRepository;

  /// Execute user registration
  Future<AppResultService<AuthUser>> execute({
    required String email,
    required String password,
    String? name,
    String? photoUrl,
  }) async {
    // Create user entity with validation
    final userResult = User.create(
      email: email,
      password: password,
      name: name,
      photoUrl: photoUrl,
    );

    if (userResult.isFailure) {
      return AppResultService.failure(userResult.errorMessage!);
    }

    // Register user
    return await _authRepository.register(userResult.valueOrNull!);
  }
}
