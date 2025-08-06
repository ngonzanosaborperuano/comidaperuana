import 'package:recetasperuanas/core/auth/models/auth_user.dart';
import 'package:recetasperuanas/domain/auth/entities/user.dart';
import 'package:recetasperuanas/domain/auth/value_objects/email.dart';
import 'package:recetasperuanas/domain/core/value_objects.dart';

/// Interface for user authentication operations
abstract class IUserAuthRepository {
  /// Authenticate user with email and password
  Future<Result<AuthUser, DomainException>> authenticateGoogle();
  Future<Result<AuthUser, DomainException>> authenticateEmail(Email email, String password);

  /// Register new user
  Future<Result<AuthUser, DomainException>> register(User user);

  /// Sign out current user
  Future<Result<void, DomainException>> signOut();

  /// Get current authenticated user
  Future<Result<User?, DomainException>> getCurrentUser();

  /// Check if user is authenticated
  Future<Result<bool, DomainException>> isAuthenticated();
}
