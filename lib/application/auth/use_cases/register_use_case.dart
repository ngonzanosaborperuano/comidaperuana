import 'package:recetasperuanas/core/auth/models/auth_user.dart' show AuthUser;
import 'package:recetasperuanas/domain/auth/entities/user.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:recetasperuanas/domain/core/value_objects.dart';

class RegisterUseCase {
  const RegisterUseCase(this._authRepository);

  final IUserAuthRepository _authRepository;

  /// Execute user registration
  Future<Result<AuthUser, DomainException>> execute({
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
      return Failure(userResult.failureValue!);
    }

    // Register user
    return await _authRepository.register(userResult.successValue!);
  }
}
