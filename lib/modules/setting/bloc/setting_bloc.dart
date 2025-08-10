import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:recetasperuanas/application/auth/use_cases/logout_use_case.dart';
import 'package:recetasperuanas/core/preferences/preferences.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_repository.dart';
import 'package:recetasperuanas/shared/models/user_model.dart';

// Events
abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object?> get props => [];
}

class SettingLoadRequested extends SettingEvent {}

class SettingLogoutRequested extends SettingEvent {}

class SettingAutoRotationToggled extends SettingEvent {
  final bool enabled;
  const SettingAutoRotationToggled(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

// States
abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object?> get props => [];
}

class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

class SettingLoaded extends SettingState {
  final UserModel user;
  final bool isAutoRotationEnabled;
  const SettingLoaded({required this.user, required this.isAutoRotationEnabled});

  @override
  List<Object?> get props => [user, isAutoRotationEnabled];
}

class SettingError extends SettingState {
  final String message;
  const SettingError(this.message);

  @override
  List<Object?> get props => [message];
}

class SettingLoggedOut extends SettingState {}

// Bloc
class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc({required IUserRepository userRepository, required LogoutUseCase logoutUseCase})
    : _userRepository = userRepository,
      _logoutUseCase = logoutUseCase,
      super(SettingInitial()) {
    on<SettingLoadRequested>(_onLoadRequested);
    on<SettingLogoutRequested>(_onLogoutRequested);
    on<SettingAutoRotationToggled>(_onAutoRotationToggled);
  }

  final IUserRepository _userRepository;
  final LogoutUseCase _logoutUseCase;

  Future<void> _onLoadRequested(SettingLoadRequested event, Emitter<SettingState> emit) async {
    emit(SettingLoading());
    try {
      final authUser = await _userRepository.getUser();
      final enabled = SharedPreferencesHelper.instance.getBool(CacheConstants.autoRotation);

      // Mapear AuthUser a UserModel para UI consistente
      final fullName = (authUser.nombreCompleto ?? '').trim();
      final parts = fullName.isEmpty ? <String>[] : fullName.split(RegExp(r"\s+"));
      final firstName = parts.isNotEmpty ? parts.first : '';
      final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

      final userModel = UserModel(
        id: authUser.id ?? 0,
        email: authUser.email,
        firstName: firstName,
        lastName: lastName,
        avatar: authUser.foto ?? '',
      );

      emit(SettingLoaded(user: userModel, isAutoRotationEnabled: enabled));
    } catch (e) {
      emit(SettingError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(SettingLogoutRequested event, Emitter<SettingState> emit) async {
    try {
      final result = await _logoutUseCase.execute();
      if (result.isSuccess) {
        await _userRepository.logout();
        emit(SettingLoggedOut());
      } else {
        emit(SettingError(result.failureValue!.message));
      }
    } catch (e) {
      emit(SettingError(e.toString()));
    }
  }

  Future<void> _onAutoRotationToggled(
    SettingAutoRotationToggled event,
    Emitter<SettingState> emit,
  ) async {
    final current = state;
    if (current is SettingLoaded) {
      try {
        await SharedPreferencesHelper.instance.setBool(
          CacheConstants.autoRotation,
          value: event.enabled,
        );
        await _updateDeviceOrientation(event.enabled);
        emit(SettingLoaded(user: current.user, isAutoRotationEnabled: event.enabled));
      } catch (e) {
        emit(SettingError(e.toString()));
      }
    }
  }

  Future<void> _updateDeviceOrientation(bool autoRotationEnabled) async {
    if (autoRotationEnabled) {
      await SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      await SystemChrome.setPreferredOrientations(const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }
}
