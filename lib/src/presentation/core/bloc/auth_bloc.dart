import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recetasperuanas/src/domain/auth/entities/user.dart';
import 'package:recetasperuanas/src/domain/auth/repositories/i_user_auth_repository.dart';
import 'package:recetasperuanas/src/domain/auth/value_objects/email.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const AuthSignUpRequested({required this.email, required this.password, required this.name});

  @override
  List<Object?> get props => [email, password, name];
}

class AuthSignOutRequested extends AuthEvent {}

class AuthGoogleSignInRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IUserAuthRepository _authRepository;

  AuthBloc({required IUserAuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthGoogleSignInRequested>(_onAuthGoogleSignInRequested);
  }

  void _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.getCurrentUser();
      if (result.isSuccess) {
        final user = result.valueOrNull;
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      } else {
        emit(AuthError(result.errorMessage ?? 'Error desconocido'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthSignInRequested(AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final email = Email(event.email);
      final result = await _authRepository.authenticateEmail(email, event.password);
      if (result.isSuccess) {
        final authUser = result.valueOrNull;
        // Convertir AuthUser a User
        final userResult = User.create(
          id: authUser?.id?.toString(),
          email: authUser?.email ?? '',
          name: authUser?.nombreCompleto ?? '',
        );

        if (userResult.isSuccess) {
          emit(Authenticated(userResult.valueOrNull!));
        } else {
          emit(AuthError(userResult.errorMessage ?? 'Error al crear usuario'));
        }
      } else {
        emit(AuthError(result.errorMessage ?? 'Error al iniciar sesión'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthSignUpRequested(AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userResult = User.create(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      if (userResult.isSuccess) {
        final user = userResult.valueOrNull!;
        final result = await _authRepository.register(user);

        if (result.isSuccess) {
          final authUser = result.valueOrNull;
          // Convertir AuthUser a User
          final finalUserResult = User.create(
            id: authUser?.id?.toString(),
            email: authUser?.email ?? '',
            name: authUser?.nombreCompleto ?? '',
          );

          if (finalUserResult.isSuccess) {
            emit(Authenticated(finalUserResult.valueOrNull!));
          } else {
            emit(AuthError(finalUserResult.errorMessage ?? 'Error al crear usuario'));
          }
        } else {
          emit(AuthError(result.errorMessage ?? 'Error al registrar usuario'));
        }
      } else {
        emit(AuthError(userResult.errorMessage ?? 'Error al validar datos'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthSignOutRequested(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.signOut();
      if (result.isSuccess) {
        emit(Unauthenticated());
      } else {
        emit(AuthError(result.errorMessage ?? 'Error al cerrar sesión'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onAuthGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.authenticateGoogle();
      if (result.isSuccess) {
        final authUser = result.valueOrNull;
        // Convertir AuthUser a User
        final userResult = User.create(
          id: authUser?.id?.toString(),
          email: authUser?.email ?? '',
          name: authUser?.nombreCompleto ?? '',
        );

        if (userResult.isSuccess) {
          emit(Authenticated(userResult.valueOrNull!));
        } else {
          emit(AuthError(userResult.errorMessage ?? 'Error al crear usuario'));
        }
      } else {
        emit(AuthError(result.errorMessage ?? 'Error al iniciar sesión con Google'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
