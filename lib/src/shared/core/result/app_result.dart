import 'package:equatable/equatable.dart';

/// Simple Result pattern for functional error handling
sealed class AppResult<T> extends Equatable {
  const AppResult();

  /// Create a success result
  const factory AppResult.success(T value) = Success<T>;

  /// Create a failure result
  const factory AppResult.failure(String message, {String? code}) = Failure<T>;

  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is failure
  bool get isFailure => this is Failure<T>;

  /// Get success value or null
  T? get valueOrNull {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    return null;
  }

  /// Get error message or null
  String? get errorMessage {
    if (this is Failure<T>) {
      return (this as Failure<T>).message;
    }
    return null;
  }

  /// Transform success value
  AppResult<R> map<R>(R Function(T) transform) {
    if (this is Success<T>) {
      return AppResult.success(transform((this as Success<T>).value));
    }
    return AppResult.failure((this as Failure<T>).message, code: (this as Failure<T>).code);
  }

  /// Fold to handle both cases
  R fold<R>(R Function(String) onFailure, R Function(T) onSuccess) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).value);
    }
    return onFailure((this as Failure<T>).message);
  }

  /// Get value or default
  T getOrElse(T Function() defaultValue) {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    return defaultValue();
  }
}

/// Success result
class Success<T> extends AppResult<T> {
  final T value;

  const Success(this.value);

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'Success($value)';
}

/// Failure result
class Failure<T> extends AppResult<T> {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'Failure($message)';
}

/// Extension for easier usage
extension AppResultExtensions<T> on AppResult<T> {
  /// Execute on success
  void onSuccess(void Function(T) callback) {
    if (isSuccess) {
      callback(valueOrNull as T);
    }
  }

  /// Execute on failure
  void onFailure(void Function(String) callback) {
    if (isFailure) {
      callback(errorMessage!);
    }
  }

  /// Execute on success or failure
  void onResult({void Function(T)? onSuccess, void Function(String)? onFailure}) {
    if (isSuccess && onSuccess != null) {
      onSuccess(valueOrNull as T);
    } else if (isFailure && onFailure != null) {
      onFailure(errorMessage!);
    }
  }
}
