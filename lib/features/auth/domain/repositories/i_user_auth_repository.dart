import 'package:goncook/core/generics/value_objects/email.dart';
import 'package:goncook/core/result/app_result.dart';
import 'package:goncook/features/auth/data/models/auth_model.dart';
import 'package:goncook/features/auth/data/models/user_model.dart';

/// Interface for user authentication operations
abstract class IUserAuthRepository {
  /// Authenticate user with email and password
  Future<AppResultService<AuthModel>> authenticateGoogle();
  Future<AppResultService<AuthModel>> authenticateEmail(Email email, String password);

  /// Register new user
  Future<AppResultService<AuthModel>> register(UserModel user);

  /// Sign out current user
  Future<AppResultService<void>> signOut();

  /// Get current authenticated user
  Future<AppResultService<UserModel?>> getCurrentUser();

  /// Check if user is authenticated
  Future<AppResultService<bool>> isAuthenticated();

  /// Recover credentials (password reset)
  Future<AppResultService<String>> recoverCredential(String email);
}
