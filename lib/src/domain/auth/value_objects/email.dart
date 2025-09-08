import 'package:recetasperuanas/src/domain/core/value_objects.dart';
import 'package:recetasperuanas/src/shared/shared.dart' show AppResult;

class Email extends ValueObject<String> {
  const Email(super.value);

  static const String _emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  @override
  bool get isValid {
    if (value.isEmpty) return false;
    return RegExp(_emailRegex).hasMatch(value);
  }

  @override
  String? get errorMessage {
    if (value.isEmpty) return 'El email no puede estar vacío';
    if (!RegExp(_emailRegex).hasMatch(value)) {
      return 'El formato del email no es válido';
    }
    return null;
  }

  /// Factory constructor that validates and returns Result
  static AppResult<Email> create(String email) {
    final emailVO = Email(email);
    if (emailVO.isValid) {
      return AppResult.success(emailVO);
    }
    return AppResult.failure(emailVO.errorMessage ?? 'Email inválido');
  }

  /// Get domain part of email
  String get domain {
    final parts = value.split('@');
    return parts.length > 1 ? parts[1] : '';
  }

  /// Get local part of email
  String get localPart {
    final parts = value.split('@');
    return parts.isNotEmpty ? parts[0] : '';
  }
}
