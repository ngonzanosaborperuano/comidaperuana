import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goncook/src/domain/auth/entities/user.dart';
import 'package:goncook/src/domain/auth/repositories/i_user_repository.dart';
import 'package:goncook/src/infrastructure/auth/models/auth_user.dart';

// Events
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UserLoadRequested extends UserEvent {}

class UserUpdateRequested extends UserEvent {
  final User user;
  const UserUpdateRequested(this.user);

  @override
  List<Object?> get props => [user];
}

class UserSignInOrRegisterRequested extends UserEvent {
  final User user;
  const UserSignInOrRegisterRequested(this.user);

  @override
  List<Object?> get props => [user];
}

// States
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  final IUserRepository _userRepository;

  UserBloc({required IUserRepository userRepository})
    : _userRepository = userRepository,
      super(UserInitial()) {
    on<UserLoadRequested>(_onUserLoadRequested);
    on<UserUpdateRequested>(_onUserUpdateRequested);
    on<UserSignInOrRegisterRequested>(_onUserSignInOrRegisterRequested);
  }

  void _onUserLoadRequested(UserLoadRequested event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      // Implementar lógica para cargar usuario
      emit(const UserError('Función no implementada'));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void _onUserUpdateRequested(UserUpdateRequested event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      // Implementar lógica para actualizar usuario
      emit(const UserError('Función no implementada'));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void _onUserSignInOrRegisterRequested(
    UserSignInOrRegisterRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      // Convertir User a AuthUser
      final authUser = AuthUser(
        id: int.tryParse(event.user.id.value),
        email: event.user.email.value,
        nombreCompleto: event.user.name,
        contrasena: null,
        sessionToken: null,
        foto: null,
      );

      final (success, message) = await _userRepository.signInOrRegister(authUser);
      if (success) {
        emit(UserLoaded(event.user));
      } else {
        emit(UserError(message));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
