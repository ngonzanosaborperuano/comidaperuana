import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeToggleRequested extends ThemeEvent {
  final bool isDark;
  const ThemeToggleRequested(this.isDark);

  @override
  List<Object?> get props => [isDark];
}

class ThemeSystemRequested extends ThemeEvent {}

class ThemePlatformBrightnessChanged extends ThemeEvent {
  final Brightness brightness;
  const ThemePlatformBrightnessChanged(this.brightness);

  @override
  List<Object?> get props => [brightness];
}

// States
abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object?> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;
  const ThemeLoaded(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> with WidgetsBindingObserver {
  ThemeBloc() : super(ThemeInitial()) {
    on<ThemeToggleRequested>(_onThemeToggleRequested);
    on<ThemeSystemRequested>(_onThemeSystemRequested);
    on<ThemePlatformBrightnessChanged>(_onThemePlatformBrightnessChanged);

    // Inicializar con el tema del dispositivo
    add(
      ThemePlatformBrightnessChanged(WidgetsBinding.instance.platformDispatcher.platformBrightness),
    );

    // Escuchar cambios en el tema del sistema
    WidgetsBinding.instance.addObserver(this);
  }

  void _onThemeToggleRequested(ThemeToggleRequested event, Emitter<ThemeState> emit) {
    final newThemeMode = event.isDark ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeLoaded(newThemeMode));
  }

  void _onThemeSystemRequested(ThemeSystemRequested event, Emitter<ThemeState> emit) {
    emit(const ThemeLoaded(ThemeMode.system));
  }

  void _onThemePlatformBrightnessChanged(
    ThemePlatformBrightnessChanged event,
    Emitter<ThemeState> emit,
  ) {
    if (state is ThemeLoaded && (state as ThemeLoaded).themeMode == ThemeMode.system) {
      final newThemeMode = _getDeviceTheme(event.brightness);
      emit(ThemeLoaded(newThemeMode));
    } else if (state is ThemeInitial) {
      final newThemeMode = _getDeviceTheme(event.brightness);
      emit(ThemeLoaded(newThemeMode));
    }
  }

  ThemeMode _getDeviceTheme(Brightness brightness) {
    switch (brightness) {
      case Brightness.dark:
        return ThemeMode.dark;
      case Brightness.light:
        return ThemeMode.light;
    }
  }

  void updatePlatformBrightness(Brightness brightness) {
    add(ThemePlatformBrightnessChanged(brightness));
  }

  // Escucha cambios en el tema del sistema
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();

    // Solo actualizar si estamos siguiendo el tema del sistema
    if (state is ThemeLoaded && (state as ThemeLoaded).themeMode == ThemeMode.system) {
      add(
        ThemePlatformBrightnessChanged(
          WidgetsBinding.instance.platformDispatcher.platformBrightness,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
