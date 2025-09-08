import 'package:recetasperuanas/src/shared/core/result/app_result.dart';

/// Base command interface
abstract class Command {
  const Command();
}

/// Command handler interface
abstract class CommandHandler<T extends Command> {
  const CommandHandler();

  /// Handle the command
  Future<AppResult<void>> handle(T command);
}

/// Command bus for handling commands
class CommandBus {
  static CommandBus? _instance;
  static CommandBus get instance => _instance ??= CommandBus._();

  CommandBus._();

  final Map<Type, CommandHandler> _handlers = {};

  /// Register a command handler
  void register<T extends Command>(CommandHandler<T> handler) {
    _handlers[T] = handler;
  }

  /// Execute a command
  Future<AppResult<void>> execute<T extends Command>(T command) async {
    final handler = _handlers[T];
    if (handler == null) {
      return AppResult.failure('No handler registered for command: ${T.toString()}');
    }

    try {
      return await handler.handle(command);
    } catch (e) {
      return AppResult.failure('Error executing command: $e');
    }
  }

  /// Clear all handlers
  void clear() {
    _handlers.clear();
  }
}

/// Base query interface
abstract class Query<T> {
  const Query();
}

/// Query handler interface
abstract class QueryHandler<Q extends Query<T>, T> {
  const QueryHandler();

  /// Handle the query
  Future<AppResult<T>> handle(Q query);
}

/// Query bus for handling queries
class QueryBus {
  static QueryBus? _instance;
  static QueryBus get instance => _instance ??= QueryBus._();

  QueryBus._();

  final Map<Type, QueryHandler> _handlers = {};

  /// Register a query handler
  void register<Q extends Query<T>, T>(QueryHandler<Q, T> handler) {
    _handlers[Q] = handler;
  }

  /// Execute a query
  Future<AppResult<T>> execute<Q extends Query<T>, T>(Q query) async {
    final handler = _handlers[Q];
    if (handler == null) {
      return AppResult.failure('No handler registered for query: ${Q.toString()}');
    }

    try {
      final result = await handler.handle(query);
      return result as AppResult<T>;
    } catch (e) {
      return AppResult.failure('Error executing query: $e');
    }
  }

  /// Clear all handlers
  void clear() {
    _handlers.clear();
  }
}
