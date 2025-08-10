import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// Events
abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppInitialized extends AppEvent {}

class AppThemeChanged extends AppEvent {
  final bool isDark;
  const AppThemeChanged(this.isDark);

  @override
  List<Object?> get props => [isDark];
}

class AppLocaleChanged extends AppEvent {
  final Locale locale;
  const AppLocaleChanged(this.locale);

  @override
  List<Object?> get props => [locale];
}

// States
abstract class AppState extends Equatable {
  const AppState();

  @override
  List<Object?> get props => [];
}

class AppInitial extends AppState {}

class AppLoaded extends AppState {
  final ThemeMode themeMode;
  final Locale locale;
  final bool isInitialized;

  const AppLoaded({
    this.themeMode = ThemeMode.system,
    this.locale = const Locale('es'),
    this.isInitialized = false,
  });

  AppLoaded copyWith({ThemeMode? themeMode, Locale? locale, bool? isInitialized}) {
    return AppLoaded(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }

  @override
  List<Object?> get props => [themeMode, locale, isInitialized];
}

// BLoC
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<AppInitialized>(_onAppInitialized);
    on<AppThemeChanged>(_onAppThemeChanged);
    on<AppLocaleChanged>(_onAppLocaleChanged);
  }

  void _onAppInitialized(AppInitialized event, Emitter<AppState> emit) {
    emit(const AppLoaded(isInitialized: true));
  }

  void _onAppThemeChanged(AppThemeChanged event, Emitter<AppState> emit) {
    if (state is AppLoaded) {
      final currentState = state as AppLoaded;
      final newThemeMode = event.isDark ? ThemeMode.dark : ThemeMode.light;
      emit(currentState.copyWith(themeMode: newThemeMode));
    }
  }

  void _onAppLocaleChanged(AppLocaleChanged event, Emitter<AppState> emit) {
    if (state is AppLoaded) {
      final currentState = state as AppLoaded;
      emit(currentState.copyWith(locale: event.locale));
    }
  }
}
