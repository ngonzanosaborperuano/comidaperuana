import 'package:goncook/src/domain/auth/entities/user.dart';
import 'package:goncook/src/domain/auth/value_objects/email.dart';
import 'package:goncook/src/infrastructure/auth/models/auth_user.dart';
import 'package:goncook/src/shared/core/result/app_result.dart';

/// Interface for user authentication operations
abstract class IUserAuthRepository {
  /// Authenticate user with email and password
  Future<AppResult<AuthUser>> authenticateGoogle();
  Future<AppResult<AuthUser>> authenticateEmail(Email email, String password);

  /// Register new user
  Future<AppResult<AuthUser>> register(User user);

  /// Sign out current user
  Future<AppResult<void>> signOut();

  /// Get current authenticated user
  Future<AppResult<User?>> getCurrentUser();

  /// Check if user is authenticated
  Future<AppResult<bool>> isAuthenticated();

  /// Recover credentials (password reset)
  Future<AppResult<String>> recoverCredential(String email);
}
