/// Jerarquía de errores para programación funcional con fpdart
/// 
/// Todas las clases Failure deben extender de esta clase base e implementar Equatable
/// para permitir comparación de errores en tests y lógica de negocio.
import 'package:equatable/equatable.dart';

/// Clase base abstracta para todos los tipos de errores
/// 
/// Todas las clases de error deben extender de esta clase e implementar Equatable.
abstract class Failure extends Equatable {
  /// Mensaje descriptivo del error
  final String message;
  
  /// Código opcional del error para identificación
  final String? code;

  const Failure(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Error de red/conectividad
class NetworkFailure extends Failure {
  const NetworkFailure([
    String message = 'Network error occurred',
    String? code,
  ]) : super(message, code: code);
}

/// Error del servidor
class ServerFailure extends Failure {
  /// Código de estado HTTP opcional
  final int? statusCode;

  const ServerFailure(
    String message, {
    this.statusCode,
    String? code,
  }) : super(message, code: code);

  @override
  List<Object?> get props => [message, code, statusCode];
}

/// Error de validación
class ValidationFailure extends Failure {
  /// Errores por campo opcionales
  final Map<String, String>? fieldErrors;

  const ValidationFailure(
    String message, {
    this.fieldErrors,
    String? code,
  }) : super(message, code: code);

  @override
  List<Object?> get props => [message, code, fieldErrors];
}

/// Error de caché
class CacheFailure extends Failure {
  const CacheFailure([
    String message = 'Cache error occurred',
    String? code,
  ]) : super(message, code: code);
}

/// Error de autenticación
class AuthFailure extends Failure {
  const AuthFailure([
    String message = 'Authentication failed',
    String? code,
  ]) : super(message, code: code);
}

/// Error desconocido/no categorizado
class UnknownFailure extends Failure {
  const UnknownFailure([
    String message = 'An unknown error occurred',
    String? code,
  ]) : super(message, code: code);
}

/// Error de plataforma nativa
class PlatformFailure extends Failure {
  const PlatformFailure(
    String message, {
    String? code,
  }) : super(message, code: code);
}
