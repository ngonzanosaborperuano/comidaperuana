import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// Events
abstract class LocaleEvent extends Equatable {
  const LocaleEvent();

  @override
  List<Object?> get props => [];
}

class LocaleChanged extends LocaleEvent {
  final Locale locale;
  const LocaleChanged(this.locale);

  @override
  List<Object?> get props => [locale];
}

class LocaleInitialized extends LocaleEvent {}

// States
abstract class LocaleState extends Equatable {
  const LocaleState();

  @override
  List<Object?> get props => [];
}

class LocaleInitial extends LocaleState {}

class LocaleLoaded extends LocaleState {
  final Locale locale;
  const LocaleLoaded(this.locale);

  @override
  List<Object?> get props => [locale];
}

// BLoC
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleInitial()) {
    on<LocaleChanged>(_onLocaleChanged);
    on<LocaleInitialized>(_onLocaleInitialized);

    // Inicializar con el idioma del dispositivo
    add(LocaleInitialized());
  }

  void _onLocaleChanged(LocaleChanged event, Emitter<LocaleState> emit) {
    if (['en', 'es'].contains(event.locale.languageCode)) {
      emit(LocaleLoaded(event.locale));
    }
  }

  void _onLocaleInitialized(LocaleInitialized event, Emitter<LocaleState> emit) {
    final deviceLocale = _getDeviceLocale();
    emit(LocaleLoaded(deviceLocale));
  }

  // Detecta automáticamente el idioma del dispositivo
  Locale _getDeviceLocale() {
    final deviceLocale = Platform.localeName;
    final languageCode = deviceLocale.split('_')[0];

    // Si el idioma del dispositivo es soportado, lo usa; si no, usa español por defecto
    if (['en', 'es'].contains(languageCode)) {
      return Locale(languageCode);
    }

    return const Locale('es'); // Idioma por defecto
  }
}
