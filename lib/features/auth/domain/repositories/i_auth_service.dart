import 'package:goncook/common/shared.dart' show AppResultService;
import 'package:goncook/core/generics/value_objects/email.dart';
import 'package:goncook/core/generics/value_objects/password.dart';
import 'package:goncook/features/auth/data/models/user_model.dart';

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
  AppResultService<void> canUserPerformAction(UserModel user, String action);

  /// Generate secure token for user
  AppResultService<String> generateSecureToken(UserModel user);

  /// Validate token
  AppResultService<bool> validateToken(String token);

  /// Hash password securely
  AppResultService<String> hashPassword(Password password);

  /// Verify password against hash
  AppResultService<bool> verifyPassword(Password password, String hash);
}
