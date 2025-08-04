import 'package:recetasperuanas/domain/auth/entities/user.dart';
import 'package:recetasperuanas/domain/auth/value_objects/email.dart';
import 'package:recetasperuanas/domain/auth/value_objects/password.dart';
import 'package:recetasperuanas/domain/core/value_objects.dart';

/// Domain service for authentication business logic
abstract class IAuthService {
  /// Validate login credentials
  Result<void, DomainException> validateLoginCredentials(
    Email email,
    Password password,
  );

  /// Validate registration data
  Result<void, DomainException> validateRegistrationData({
    required Email email,
    required Password password,
    String? name,
  });

  /// Check if user can perform action
  Result<void, DomainException> canUserPerformAction(User user, String action);

  /// Generate secure token for user
  Result<String, DomainException> generateSecureToken(User user);

  /// Validate token
  Result<bool, DomainException> validateToken(String token);

  /// Hash password securely
  Result<String, DomainException> hashPassword(Password password);

  /// Verify password against hash
  Result<bool, DomainException> verifyPassword(Password password, String hash);
}
