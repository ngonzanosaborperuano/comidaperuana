import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class ConfigEvent extends Equatable {
  const ConfigEvent();

  @override
  List<Object?> get props => [];
}

class ConfigLoadRequested extends ConfigEvent {}

class ConfigUpdateRequested extends ConfigEvent {
  final Map<String, dynamic> config;
  const ConfigUpdateRequested(this.config);

  @override
  List<Object?> get props => [config];
}

// States
abstract class ConfigState extends Equatable {
  const ConfigState();

  @override
  List<Object?> get props => [];
}

class ConfigInitial extends ConfigState {}

class ConfigLoading extends ConfigState {}

class ConfigLoaded extends ConfigState {
  final Map<String, dynamic> config;
  const ConfigLoaded(this.config);

  @override
  List<Object?> get props => [config];
}

class ConfigError extends ConfigState {
  final String message;
  const ConfigError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class ConfigBloc extends Bloc<ConfigEvent, ConfigState> {
  final Map<String, dynamic> _config;

  ConfigBloc({required Map<String, dynamic> config}) : _config = config, super(ConfigInitial()) {
    on<ConfigLoadRequested>(_onConfigLoadRequested);
    on<ConfigUpdateRequested>(_onConfigUpdateRequested);
  }

  void _onConfigLoadRequested(ConfigLoadRequested event, Emitter<ConfigState> emit) async {
    emit(ConfigLoading());
    try {
      emit(ConfigLoaded(_config));
    } catch (e) {
      emit(ConfigError(e.toString()));
    }
  }

  void _onConfigUpdateRequested(ConfigUpdateRequested event, Emitter<ConfigState> emit) async {
    emit(ConfigLoading());
    try {
      // Aquí se implementaría la lógica para actualizar la configuración
      emit(ConfigLoaded(event.config));
    } catch (e) {
      emit(ConfigError(e.toString()));
    }
  }
}
