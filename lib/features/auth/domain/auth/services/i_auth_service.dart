import 'package:goncook/common/shared.dart' show AppResultService;
import 'package:goncook/features/auth/domain/auth/entities/user.dart';
import 'package:goncook/features/auth/domain/auth/value_objects/email.dart';
import 'package:goncook/features/auth/domain/auth/value_objects/password.dart';

/// Domain service for authentication business logic
abstract class IAuthService {
  /// Validate login credentials
  AppResultService<void> validateLoginCredentials(Email email, Password password);

  /// Validate registration data
  AppResultService<void> validateRegistrationData({
    required Email email,
    required Password password,
    String? name,
  });

  /// Check if user can perform action
  AppResultService<void> canUserPerformAction(User user, String action);

  /// Generate secure token for user
  AppResultService<String> generateSecureToken(User user);

  /// Validate token
  AppResultService<bool> validateToken(String token);

  /// Hash password securely
  AppResultService<String> hashPassword(Password password);

  /// Verify password against hash
  AppResultService<bool> verifyPassword(Password password, String hash);
}
