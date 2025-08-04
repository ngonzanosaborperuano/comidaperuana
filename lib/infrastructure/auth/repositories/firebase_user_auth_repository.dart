import 'package:recetasperuanas/domain/auth/entities/user.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:recetasperuanas/domain/auth/value_objects/email.dart';
import 'package:recetasperuanas/domain/core/value_objects.dart';

/// Mock implementation of user authentication repository for development
class FirebaseUserAuthRepository implements IUserAuthRepository {
  FirebaseUserAuthRepository();

  @override
  Future<Result<User, DomainException>> authenticate(
    Email email,
    String password,
  ) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));

    if (email.value == 'test@example.com' && password == 'Password123') {
      final user = User.createWithoutPassword(
        id: 'mock-user-id-123',
        email: email.value,
        name: 'Usuario de Prueba',
      );

      if (user.isFailure) {
        return Failure(user.failureValue!);
      }

      return Success(user.successValue!);
    }

    return const Failure(ValidationException('Credenciales inválidas'));
  }

  @override
  Future<Result<User, DomainException>> register(User user) async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));

    final createdUser = User.createWithoutPassword(
      id: 'mock-user-id-${DateTime.now().millisecondsSinceEpoch}',
      email: user.email.value,
      name: user.name,
      photoUrl: user.photoUrl,
    );

    if (createdUser.isFailure) {
      return Failure(createdUser.failureValue!);
    }

    return Success(createdUser.successValue!);
  }

  @override
  Future<Result<User, DomainException>> authenticateWithGoogle() async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 500));

    final user = User.createWithoutPassword(
      id: 'mock-google-user-id-123',
      email: 'google@example.com',
      name: 'Usuario Google',
      photoUrl: 'https://example.com/avatar.jpg',
    );

    if (user.isFailure) {
      return Failure(user.failureValue!);
    }

    return Success(user.successValue!);
  }

  @override
  Future<Result<void, DomainException>> signOut() async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 300));
    return const Success(null);
  }

  @override
  Future<Result<User?, DomainException>> getCurrentUser() async {
    // Mock implementation - returns null for now
    await Future.delayed(const Duration(milliseconds: 200));
    return const Success(null);
  }

  @override
  Future<Result<bool, DomainException>> isAuthenticated() async {
    // Mock implementation
    await Future.delayed(const Duration(milliseconds: 100));
    return const Success(false);
  }
}
