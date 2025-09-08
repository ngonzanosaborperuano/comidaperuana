import 'package:equatable/equatable.dart';

/// Base class for all Value Objects
abstract class ValueObject<T> extends Equatable {
  const ValueObject(this.value);

  final T value;

  /// Validate the value according to domain rules
  bool get isValid;

  /// Get validation error message
  String? get errorMessage;

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value.toString();
}

// Result pattern moved to shared/core/result/app_result.dart

/// Domain exceptions
abstract class DomainException implements Exception {
  const DomainException(this.message);
  final String message;

  @override
  String toString() => message;
}

class ValidationException extends DomainException {
  const ValidationException(super.message);
}

class BusinessRuleException extends DomainException {
  const BusinessRuleException(super.message);
}
