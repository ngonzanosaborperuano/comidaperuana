import 'package:recetasperuanas/src/domain/auth/entities/user.dart';
import 'package:recetasperuanas/src/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:recetasperuanas/src/infrastructure/auth/models/auth_user.dart' show AuthUser;
import 'package:recetasperuanas/src/shared/shared.dart' show AppResult;

class RegisterUseCase {
  const RegisterUseCase(this._authRepository);

  final IUserAuthRepository _authRepository;

  /// Execute user registration
  Future<AppResult<AuthUser>> execute({
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
      return AppResult.failure(userResult.errorMessage!);
    }

    // Register user
    return await _authRepository.register(userResult.valueOrNull!);
  }
}
