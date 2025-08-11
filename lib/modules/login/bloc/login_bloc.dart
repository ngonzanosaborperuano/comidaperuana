import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recetasperuanas/application/auth/use_cases/login_use_case.dart';
import 'package:recetasperuanas/application/auth/use_cases/logout_use_case.dart';
import 'package:recetasperuanas/application/auth/use_cases/register_use_case.dart';
import 'package:recetasperuanas/core/auth/models/auth_user.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_repository.dart';
import 'package:recetasperuanas/modules/login/bloc/login_event.dart'
    show LoginEvent, LoginRequested, RegisterRequested, LogoutRequested;

class RecoverCredentialRequested extends LoginEvent {
  final String email;

  const RecoverCredentialRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class LoginErrorCleared extends LoginEvent {}

class PasswordVisibilityToggled extends LoginEvent {}

// States
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final AuthUser user;
  final String message;

  const LoginSuccess({required this.user, required this.message});

  @override
  List<Object?> get props => [user, message];
}

class RegisterSuccess extends LoginState {
  final AuthUser user;
  final String message;

  const RegisterSuccess({required this.user, required this.message});

  @override
  List<Object?> get props => [user, message];
}

class LogoutSuccess extends LoginState {
  final String message;

  const LogoutSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class RecoverCredentialSuccess extends LoginState {
  final String message;

  const RecoverCredentialSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginFormState extends LoginState {
  final bool isPasswordVisible;
  final String? emailError;
  final String? passwordError;

  const LoginFormState({this.isPasswordVisible = true, this.emailError, this.passwordError});

  LoginFormState copyWith({bool? isPasswordVisible, String? emailError, String? passwordError}) {
    return LoginFormState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
    );
  }

  @override
  List<Object?> get props => [isPasswordVisible, emailError, passwordError];
}

// BLoC
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final IUserRepository _userRepository;

  LoginBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required IUserRepository userRepository,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _userRepository = userRepository,
       super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<RecoverCredentialRequested>(_onRecoverCredentialRequested);
    on<LoginErrorCleared>(_onLoginErrorCleared);
    on<PasswordVisibilityToggled>(_onPasswordVisibilityToggled);
  }

  void _onLoginRequested(LoginRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final result = await _loginUseCase.execute(
        email: event.email,
        password: event.password,
        type: event.type,
      );

      if (result.isSuccess) {
        final (isSuccess, msg) = await _userRepository.signInOrRegister(result.successValue!);
        if (isSuccess) {
          emit(LoginSuccess(user: result.successValue!, message: 'Inicio de sesión exitoso'));
        } else {
          emit(LoginError(msg));
        }
      } else {
        emit(LoginError(result.failureValue!.message));
      }
    } catch (e) {
      emit(LoginError('Error inesperado: $e'));
    }
  }

  void _onRegisterRequested(RegisterRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final result = await _registerUseCase.execute(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      if (result.isSuccess) {
        emit(RegisterSuccess(user: result.successValue!, message: 'Registro exitoso'));
      } else {
        emit(LoginError(result.failureValue!.message));
      }
    } catch (e) {
      emit(LoginError('Error inesperado: $e'));
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<LoginState> emit) async {
    emit(LoginLoading());

    try {
      final result = await _logoutUseCase.execute();

      if (result.isSuccess) {
        emit(const LogoutSuccess('Sesión cerrada exitosamente'));
      } else {
        emit(LoginError(result.failureValue!.message));
      }
    } catch (e) {
      emit(LoginError('Error inesperado: $e'));
    }
  }

  void _onRecoverCredentialRequested(
    RecoverCredentialRequested event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final result = await _loginUseCase.executeRecoverCredential(event.email);
      if (result.isSuccess) {
        emit(const RecoverCredentialSuccess('Correo de recuperación enviado'));
      } else {
        emit(LoginError(result.failureValue!.message));
      }
    } catch (e) {
      emit(LoginError('Error inesperado: $e'));
    }
  }

  void _onLoginErrorCleared(LoginErrorCleared event, Emitter<LoginState> emit) {
    emit(LoginInitial());
  }

  void _onPasswordVisibilityToggled(PasswordVisibilityToggled event, Emitter<LoginState> emit) {
    if (state is LoginFormState) {
      final currentState = state as LoginFormState;
      emit(currentState.copyWith(isPasswordVisible: !currentState.isPasswordVisible));
    } else {
      emit(const LoginFormState(isPasswordVisible: false));
    }
  }

  // Validation methods
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'El email no puede estar vacío';
    }

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return 'El formato del email no es válido';
    }

    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'La contraseña no puede estar vacía';
    }

    if (password.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    if (!RegExp(r'^(?=.*[A-Z])').hasMatch(password)) {
      return 'La contraseña debe contener al menos una mayúscula';
    }

    if (!RegExp(r'^(?=.*[a-z])').hasMatch(password)) {
      return 'La contraseña debe contener al menos una minúscula';
    }

    if (!RegExp(r'^(?=.*\d)').hasMatch(password)) {
      return 'La contraseña debe contener al menos un número';
    }

    return null;
  }
}
