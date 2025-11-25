import 'package:goncook/src/domain/core/value_objects.dart';
import 'package:goncook/src/shared/shared.dart' show AppResult;

class UserId extends ValueObject<String> {
  const UserId(super.value);

  @override
  bool get isValid {
    if (value.isEmpty) return false;
    // Allow integer IDs (1, 2, 465, etc.)
    return RegExp(r'^\d+$').hasMatch(value);
  }

  @override
  String? get errorMessage {
    if (value.isEmpty) return 'El ID de usuario no puede estar vacío';
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'El ID de usuario debe ser un número entero';
    }
    return null;
  }

  /// Factory constructor that validates and returns Result
  static AppResult<UserId> create(String userId) {
    final userIdVO = UserId(userId);
    if (userIdVO.isValid) {
      return AppResult.success(userIdVO);
    }
    return AppResult.failure(userIdVO.errorMessage ?? 'ID de usuario inválido');
  }

  /// Create from Firebase UID
  static UserId fromFirebaseUid(String uid) {
    return UserId(uid);
  }

  /// Check if this is a valid Firebase UID
  bool get isFirebaseUid => isValid;
}
