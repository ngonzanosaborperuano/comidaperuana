import 'package:recetasperuanas/domain/auth/entities/user.dart';
import 'package:recetasperuanas/domain/auth/value_objects/email.dart';
import 'package:recetasperuanas/domain/auth/value_objects/user_id.dart';
import 'package:recetasperuanas/domain/core/value_objects.dart';

/// Interface for user repository operations
abstract class IUserRepository {
  /// Find user by ID
  Future<Result<User?, DomainException>> findById(UserId id);

  /// Find user by email
  Future<Result<User?, DomainException>> findByEmail(Email email);

  /// Save user (create or update)
  Future<Result<User, DomainException>> save(User user);

  /// Delete user by ID
  Future<Result<void, DomainException>> delete(UserId id);

  /// Check if user exists by email
  Future<Result<bool, DomainException>> existsByEmail(Email email);

  /// Get all active users
  Future<Result<List<User>, DomainException>> findAllActive();
}

/// Interface for user authentication operations
abstract class IUserAuthRepository {
  /// Authenticate user with email and password
  Future<Result<User, DomainException>> authenticate(
    Email email,
    String password,
  );

  /// Register new user
  Future<Result<User, DomainException>> register(User user);

  /// Authenticate with Google
  Future<Result<User, DomainException>> authenticateWithGoogle();

  /// Sign out current user
  Future<Result<void, DomainException>> signOut();

  /// Get current authenticated user
  Future<Result<User?, DomainException>> getCurrentUser();

  /// Check if user is authenticated
  Future<Result<bool, DomainException>> isAuthenticated();
}
