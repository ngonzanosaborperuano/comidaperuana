import 'package:goncook/common/shared.dart' show AppResult;
import 'package:goncook/features/auth/domain/auth/entities/user.dart';
import 'package:goncook/features/auth/domain/auth/value_objects/email.dart';
import 'package:goncook/features/auth/domain/auth/value_objects/password.dart';

/// Domain service for authentication business logic
abstract class IAuthService {
  /// Validate login credentials
  AppResult<void> validateLoginCredentials(Email email, Password password);

  /// Validate registration data
  AppResult<void> validateRegistrationData({
    required Email email,
    required Password password,
    String? name,
  });

  /// Check if user can perform action
  AppResult<void> canUserPerformAction(User user, String action);

  /// Generate secure token for user
  AppResult<String> generateSecureToken(User user);

  /// Validate token
  AppResult<bool> validateToken(String token);

  /// Hash password securely
  AppResult<String> hashPassword(Password password);

  /// Verify password against hash
  AppResult<bool> verifyPassword(Password password, String hash);
}
