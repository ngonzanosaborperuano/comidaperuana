import 'package:equatable/equatable.dart';
import 'package:logging/logging.dart';

/// Base domain event
abstract class DomainEvent extends Equatable {
  const DomainEvent({required this.aggregateId, required this.version, required this.timestamp});

  final String aggregateId;
  final int version;
  final DateTime timestamp;

  @override
  List<Object?> get props => [aggregateId, version, timestamp];
}

/// Event store interface
abstract class EventStore {
  /// Save events
  Future<void> saveEvents(String aggregateId, List<DomainEvent> events, int expectedVersion);

  /// Get events for aggregate
  Future<List<DomainEvent>> getEvents(String aggregateId);

  /// Get all events
  Future<List<DomainEvent>> getAllEvents();
}

/// Event bus for publishing events
class EventBus {
  static EventBus? _instance;
  static EventBus get instance => _instance ??= EventBus._();

  EventBus._();

  final Map<Type, List<Function(DomainEvent)>> _handlers = {};

  /// Subscribe to events
  void subscribe<T extends DomainEvent>(Function(T) handler) {
    _handlers[T] ??= [];
    _handlers[T]!.add(handler as Function(DomainEvent));
  }

  /// Publish event
  void publish(DomainEvent event) {
    final handlers = _handlers[event.runtimeType];
    if (handlers != null) {
      for (final handler in handlers) {
        handler(event);
      }
    }
  }

  /// Unsubscribe from events
  void unsubscribe<T extends DomainEvent>(Function(T) handler) {
    final handlers = _handlers[T];
    if (handlers != null) {
      handlers.remove(handler as Function(DomainEvent));
    }
  }

  /// Clear all handlers
  void clear() {
    _handlers.clear();
  }
}

/// Aggregate root base class
abstract class AggregateRoot {
  AggregateRoot(this.id) : _version = 0;

  final String id;
  int _version;
  final List<DomainEvent> _uncommittedEvents = [];

  int get version => _version;
  List<DomainEvent> get uncommittedEvents => List.unmodifiable(_uncommittedEvents);

  /// Apply event to aggregate
  void apply(DomainEvent event) {
    _uncommittedEvents.add(event);
    _version++;
  }

  /// Mark events as committed
  void markEventsAsCommitted() {
    _uncommittedEvents.clear();
  }

  /// Load from events
  void loadFromHistory(List<DomainEvent> events) {
    for (final event in events) {
      apply(event);
    }
    markEventsAsCommitted();
  }
}

/// Event handler interface
abstract class EventHandler<T extends DomainEvent> {
  const EventHandler();

  /// Handle the event
  Future<void> handle(T event);
}

/// Event handler decorator for logging
class LoggingEventHandler<T extends DomainEvent> implements EventHandler<T> {
  const LoggingEventHandler(this._handler);

  final EventHandler<T> _handler;
  static final Logger _logger = Logger('LoggingEventHandler');

  @override
  Future<void> handle(T event) async {
    _logger.info('Handling event: ${event.runtimeType} for aggregate: ${event.aggregateId}');
    await _handler.handle(event);
    _logger.info('Event handled successfully');
  }
}
