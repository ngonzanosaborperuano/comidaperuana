/// Jerarquía de errores para programación funcional con fpdart
/// 
/// Todas las clases Failure deben extender de esta clase base e implementar Equatable
/// para permitir comparación de errores en tests y lógica de negocio.
library;
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
    super.message = 'Network error occurred',
    String? code,
  ]) : super(code: code);
}

/// Error del servidor
class ServerFailure extends Failure {
  /// Código de estado HTTP opcional
  final int? statusCode;

  const ServerFailure(
    super.message, {
    this.statusCode,
    super.code,
  });

  @override
  List<Object?> get props => [message, code, statusCode];
}

/// Error de validación
class ValidationFailure extends Failure {
  /// Errores por campo opcionales
  final Map<String, String>? fieldErrors;

  const ValidationFailure(
    super.message, {
    this.fieldErrors,
    super.code,
  });

  @override
  List<Object?> get props => [message, code, fieldErrors];
}

/// Error de caché
class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Cache error occurred',
    String? code,
  ]) : super(code: code);
}

/// Error de autenticación
class AuthFailure extends Failure {
  const AuthFailure([
    super.message = 'Authentication failed',
    String? code,
  ]) : super(code: code);
}

/// Error desconocido/no categorizado
class UnknownFailure extends Failure {
  const UnknownFailure([
    super.message = 'An unknown error occurred',
    String? code,
  ]) : super(code: code);
}

/// Error de plataforma nativa
class PlatformFailure extends Failure {
  const PlatformFailure(
    super.message, {
    super.code,
  });
}
