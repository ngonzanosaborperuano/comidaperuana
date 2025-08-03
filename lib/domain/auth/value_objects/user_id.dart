import 'package:recetasperuanas/domain/core/value_objects.dart';

class UserId extends ValueObject<String> {
  const UserId(super.value);

  @override
  bool get isValid {
    if (value.isEmpty) return false;
    // Firebase UID validation (28 characters, alphanumeric)
    return RegExp(r'^[a-zA-Z0-9]{28}$').hasMatch(value);
  }

  @override
  String? get errorMessage {
    if (value.isEmpty) return 'El ID de usuario no puede estar vacío';
    if (!RegExp(r'^[a-zA-Z0-9]{28}$').hasMatch(value)) {
      return 'El formato del ID de usuario no es válido';
    }
    return null;
  }

  /// Factory constructor that validates and returns Result
  static Result<UserId, ValidationException> create(String userId) {
    final userIdVO = UserId(userId);
    if (userIdVO.isValid) {
      return Success(userIdVO);
    }
    return Failure(ValidationException(userIdVO.errorMessage ?? 'ID de usuario inválido'));
  }

  /// Create from Firebase UID
  static UserId fromFirebaseUid(String uid) {
    return UserId(uid);
  }

  /// Check if this is a valid Firebase UID
  bool get isFirebaseUid => isValid;
}
