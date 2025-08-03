import 'package:recetasperuanas/domain/core/value_objects.dart';

class Password extends ValueObject<String> {
  const Password(super.value);

  @override
  bool get isValid {
    if (value.isEmpty) return false;
    if (value.length < 8) return false;
    if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) return false;
    if (!RegExp(r'^(?=.*[a-z])').hasMatch(value)) return false;
    if (!RegExp(r'^(?=.*\d)').hasMatch(value)) return false;
    return true;
  }

  @override
  String? get errorMessage {
    if (value.isEmpty) return 'La contraseña no puede estar vacía';
    if (value.length < 8) return 'La contraseña debe tener al menos 8 caracteres';
    if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
      return 'La contraseña debe contener al menos una mayúscula';
    }
    if (!RegExp(r'^(?=.*[a-z])').hasMatch(value)) {
      return 'La contraseña debe contener al menos una minúscula';
    }
    if (!RegExp(r'^(?=.*\d)').hasMatch(value)) {
      return 'La contraseña debe contener al menos un número';
    }
    return null;
  }

  /// Factory constructor that validates and returns Result
  static Result<Password, ValidationException> create(String password) {
    final passwordVO = Password(password);
    if (passwordVO.isValid) {
      return Success(passwordVO);
    }
    return Failure(ValidationException(passwordVO.errorMessage ?? 'Contraseña inválida'));
  }

  /// Get password strength level
  PasswordStrength get strength {
    int score = 0;
    if (value.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(value)) score++;
    if (RegExp(r'[a-z]').hasMatch(value)) score++;
    if (RegExp(r'\d').hasMatch(value)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) score++;

    switch (score) {
      case 0:
      case 1:
        return PasswordStrength.weak;
      case 2:
      case 3:
        return PasswordStrength.medium;
      case 4:
      case 5:
        return PasswordStrength.strong;
      default:
        return PasswordStrength.weak;
    }
  }

  /// Check if password is strong enough
  bool get isStrong => strength == PasswordStrength.strong;
}

enum PasswordStrength { weak, medium, strong }
