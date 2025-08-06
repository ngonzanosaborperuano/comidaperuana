import 'package:recetasperuanas/core/auth/models/auth_user.dart';
import 'package:recetasperuanas/domain/auth/entities/user.dart';
import 'package:recetasperuanas/domain/auth/value_objects/email.dart';
import 'package:recetasperuanas/domain/auth/value_objects/user_id.dart';
import 'package:recetasperuanas/domain/core/value_objects.dart';

/// Interface for user repository operations
abstract class IUserRepositoryOLD {
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
  Future<Result<User, DomainException>> authenticate(Email email, String password);

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

/// Interface for the current UserRepository implementation
/// This interface reflects the actual methods used in the UserRepository class
abstract class IUserRepository {
  /// Login with different authentication methods
  Future<(bool, String)> login({required AuthUser user, required int type});

  /// Login with email and password
  Future<(bool, String)> loginWithEmailPass(AuthUser user);

  /// Sign in or register user
  Future<(bool, String)> signInOrRegister(AuthUser user, {int? type});

  /// Recover credentials (password reset)
  Future<String?> recoverCredential(String email);

  /// Login with email
  Future<bool> loginWithEmail(AuthUser user);

  /// Login with Google
  Future<(bool, String)> loginWithGoogle();

  /// Register new user
  Future<bool> register(AuthUser user, {int? type});

  /// Get current user
  Future<AuthUser> getUser();

  /// Logout user
  Future<void> logout();
}
