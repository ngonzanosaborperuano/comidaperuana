import 'package:recetasperuanas/core/result/app_result.dart';

/// Base saga step
abstract class SagaStep {
  const SagaStep();

  /// Execute the step
  Future<AppResult<void>> execute();

  /// Compensate the step (rollback)
  Future<AppResult<void>> compensate();
}

/// Saga orchestrator
class SagaOrchestrator {
  static SagaOrchestrator? _instance;
  static SagaOrchestrator get instance => _instance ??= SagaOrchestrator._();

  SagaOrchestrator._();

  final Map<String, Saga> _sagas = {};

  /// Register a saga
  void register(String name, Saga saga) {
    _sagas[name] = saga;
  }

  /// Execute a saga
  Future<AppResult<void>> execute(String name, Map<String, dynamic> data) async {
    final saga = _sagas[name];
    if (saga == null) {
      return AppResult.failure('Saga not found: $name');
    }

    return await saga.execute(data);
  }

  /// Get saga by name
  Saga? getSaga(String name) {
    return _sagas[name];
  }

  /// Clear all sagas
  void clear() {
    _sagas.clear();
  }
}

/// Base saga class
abstract class Saga {
  const Saga();

  /// Get saga steps
  List<SagaStep> get steps;

  /// Execute the saga
  Future<AppResult<void>> execute(Map<String, dynamic> data) async {
    final executedSteps = <SagaStep>[];

    try {
      // Execute steps in order
      for (final step in steps) {
        final result = await step.execute();
        if (result.isFailure) {
          // If step fails, compensate all executed steps
          await _compensateSteps(executedSteps);
          return result;
        }
        executedSteps.add(step);
      }

      return const AppResult.success(null);
    } catch (e) {
      // If exception occurs, compensate all executed steps
      await _compensateSteps(executedSteps);
      return AppResult.failure('Saga execution failed: $e');
    }
  }

  /// Compensate executed steps in reverse order
  Future<void> _compensateSteps(List<SagaStep> steps) async {
    for (int i = steps.length - 1; i >= 0; i--) {
      try {
        await steps[i].compensate();
      } catch (e) {
        print('Error compensating step: $e');
      }
    }
  }
}

/// Simple saga step implementation
class SimpleSagaStep implements SagaStep {
  const SimpleSagaStep({required this.executeFunction, required this.compensateFunction});

  final Future<AppResult<void>> Function() executeFunction;
  final Future<AppResult<void>> Function() compensateFunction;

  @override
  Future<AppResult<void>> execute() => executeFunction();

  @override
  Future<AppResult<void>> compensate() => compensateFunction();
}

/// Saga step with data
class DataSagaStep<T> implements SagaStep {
  DataSagaStep({required this.executeFunction, required this.compensateFunction});

  final Future<AppResult<void>> Function(T data) executeFunction;
  final Future<AppResult<void>> Function(T data) compensateFunction;

  T? _data;

  void setData(T data) {
    _data = data;
  }

  @override
  Future<AppResult<void>> execute() async {
    if (_data == null) {
      return const AppResult.failure('Data not set for saga step');
    }
    return await executeFunction(_data as T);
  }

  @override
  Future<AppResult<void>> compensate() async {
    if (_data == null) {
      return const AppResult.failure('Data not set for saga step');
    }
    return await compensateFunction(_data as T);
  }
}

/// Saga step decorator for logging
class LoggingSagaStep implements SagaStep {
  const LoggingSagaStep(this._step, this._name);

  final SagaStep _step;
  final String _name;

  @override
  Future<AppResult<void>> execute() async {
    print('Executing saga step: $_name');
    final result = await _step.execute();
    if (result.isSuccess) {
      print('Saga step $_name executed successfully');
    } else {
      print('Saga step $_name failed: ${result.errorMessage}');
    }
    return result;
  }

  @override
  Future<AppResult<void>> compensate() async {
    print('Compensating saga step: $_name');
    final result = await _step.compensate();
    if (result.isSuccess) {
      print('Saga step $_name compensated successfully');
    } else {
      print('Saga step $_name compensation failed: ${result.errorMessage}');
    }
    return result;
  }
}
