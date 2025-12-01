import 'package:goncook/core/result/app_result.dart';
import 'package:goncook/features/auth/data/models/auth_user.dart';
import 'package:goncook/features/auth/domain/auth/entities/user.dart';
import 'package:goncook/features/auth/domain/auth/value_objects/email.dart';

/// Interface for user authentication operations
abstract class IUserAuthRepository {
  /// Authenticate user with email and password
  Future<AppResultService<AuthUser>> authenticateGoogle();
  Future<AppResultService<AuthUser>> authenticateEmail(Email email, String password);

  /// Register new user
  Future<AppResultService<AuthUser>> register(User user);

  /// Sign out current user
  Future<AppResultService<void>> signOut();

  /// Get current authenticated user
  Future<AppResultService<User?>> getCurrentUser();

  /// Check if user is authenticated
  Future<AppResultService<bool>> isAuthenticated();

  /// Recover credentials (password reset)
  Future<AppResultService<String>> recoverCredential(String email);
}
