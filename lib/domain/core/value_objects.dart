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

/// Result type for operations that can fail
sealed class Result<T, E> {
  const Result();

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;

  T? get successValue => isSuccess ? (this as Success<T, E>).value : null;
  E? get failureValue => isFailure ? (this as Failure<T, E>).error : null;
}

class Success<T, E> extends Result<T, E> {
  const Success(this.value);
  final T value;
}

class Failure<T, E> extends Result<T, E> {
  const Failure(this.error);
  final E error;
}

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
