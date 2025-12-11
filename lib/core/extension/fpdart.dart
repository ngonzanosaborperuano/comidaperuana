import 'package:fpdart/fpdart.dart';
import 'package:logging/logging.dart';

final Logger _fpdartLogger = Logger('FpdartExtensions');

/// Punto único para traducir un failure a excepción.
Exception failureToException(Object failure) {
  if (failure is Exception) {
    return failure;
  }
  return Exception(failure.toString());
}

/// Extensiones para Either con side effects y acceso seguro.
extension FpdartEitherExtensions<L, R> on Either<L, R> {
  /// Ejecuta un efecto cuando el resultado es Left y retorna el Either.
  Either<L, R> onLeft(void Function(L left) effect) {
    fold(effect, (_) {});
    return this;
  }

  /// Ejecuta un efecto cuando el resultado es Right y retorna el Either.
  Either<L, R> onRight(void Function(R right) effect) {
    fold((_) {}, effect);
    return this;
  }

  /// Obtiene el valor Right o un valor por defecto si es Left.
  R getOrElse(R Function() defaultValue) {
    return fold((_) => defaultValue(), (right) => right);
  }

  /// Indica si el resultado es Right.
  bool get isRight => fold((_) => false, (_) => true);

  /// Indica si el resultado es Left.
  bool get isLeft => !isRight;

  /// Obtiene Right o lanza excepción cuando es Left.
  R getRightOrThrow(Object Function() onLeft) {
    return fold((_) => throw onLeft(), (right) => right);
  }

  /// Obtiene Left o lanza excepción cuando es Right.
  L getLeftOrThrow(Object Function() onRight) {
    return fold((left) => left, (_) => throw onRight());
  }
}

/// Extensión para reportar errores en Either con Failure como Left.
extension FpdartEitherFailureExtensions<L extends Object, R> on Either<L, R> {
  /// Reporta el Left al logger y retorna el mismo Either.
  Either<L, R> reportLeft({void Function(Exception exception)? onReport}) {
    return fold((left) {
      final exception = failureToException(left);
      _fpdartLogger.severe('Failure reportado desde Either', exception);
      onReport?.call(exception);
      return Left(left);
    }, (right) => Right(right));
  }
}

/// Extensiones para Option con side effects y acceso seguro.
extension FpdartOptionExtensions<T> on Option<T> {
  /// Ejecuta un efecto cuando existe un valor y retorna el Option.
  Option<T> onSome(void Function(T value) effect) {
    match(() {}, effect);
    return this;
  }

  /// Ejecuta un efecto cuando no existe valor y retorna el Option.
  Option<T> onNone(void Function() effect) {
    match(effect, (_) {});
    return this;
  }

  /// Indica si contiene valor.
  bool get isSome => match(() => false, (_) => true);

  /// Indica si no contiene valor.
  bool get isNone => !isSome;

  /// Obtiene el valor o lanza excepción si es None.
  T getOrThrow(Exception Function() onNone) {
    return match(() => throw onNone(), (value) => value);
  }
}

/// Extensiones para Task con conversión a Either.
extension FpdartTaskExtensions<T> on Task<T> {
  /// Ejecuta la tarea y captura errores en un Either.
  Future<Either<L, T>> toEither<L>(L Function(Object error, StackTrace stackTrace) onError) async {
    try {
      final result = await run();
      return Right(result);
    } catch (error, stackTrace) {
      return Left(onError(error, stackTrace));
    }
  }

  /// Ejecuta la tarea y convierte cualquier error en Exception como Left.
  Future<Either<Exception, T>> toEitherFailure() async {
    try {
      final result = await run();
      return Right(result);
    } catch (error, stackTrace) {
      final exception = failureToException(error);
      _fpdartLogger.severe('Error en Task', exception, stackTrace);
      return Left(exception);
    }
  }
}

/// Extensiones para TaskEither con reporte automático de errores.
extension FpdartTaskEitherExtensions<L extends Object, R> on TaskEither<L, R> {
  /// Ejecuta la tarea y reporta el Left al logger.
  Future<Either<L, R>> reportLeft({void Function(Exception exception)? onReport}) async {
    final result = await run();
    return result.reportLeft(onReport: onReport);
  }
}

/// Extensiones para ejecutar TaskEither en paralelo.
extension FpdartTaskEitherListExtensions<L extends Object, R> on List<TaskEither<L, R>> {
  /// Ejecuta todas las tareas en paralelo.
  Future<List<Either<L, R>>> runParallel() async {
    return Future.wait(map((task) => task.run()));
  }

  /// Ejecuta en paralelo y reporta cada Left.
  Future<List<Either<L, R>>> runParallelAndReport({
    void Function(Exception exception)? onReport,
  }) async {
    final results = await runParallel();
    for (final result in results) {
      result.reportLeft(onReport: onReport);
    }
    return results;
  }
}

/// Extensiones para Unit orientadas a Either.
extension FpdartUnitExtensions on Unit {
  /// Convierte Unit en un Either exitoso.
  Either<L, Unit> toEither<L>() => const Right(unit);

  /// Marca que la operación fue exitosa.
  bool get isSuccess => true;
}
