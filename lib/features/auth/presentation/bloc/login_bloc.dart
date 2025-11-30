import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goncook/features/auth/data/models/auth_user.dart';
import 'package:goncook/features/auth/domain/auth/repositories/i_user_repository.dart';
import 'package:goncook/features/auth/domain/usecases/auth_usecase.dart';
import 'package:goncook/features/auth/domain/usecases/logout_usecase.dart';
import 'package:goncook/features/auth/domain/usecases/register_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

/// BLoC responsible for managing login, registration, logout, and credential recovery flows.
///
/// Handles authentication operations including:
/// - User login with email and password
/// - User registration
/// - User logout
/// - Credential recovery via email
/// - Form validation and password visibility toggling
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
       super(const LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<RecoverCredentialRequested>(_onRecoverCredentialRequested);
    on<LoginErrorCleared>(_onLoginErrorCleared);
    on<PasswordVisibilityToggled>(_onPasswordVisibilityToggled);
  }

  void _onLoginRequested(LoginRequested event, Emitter<LoginState> emit) async {
    emit(const LoginLoading());

    try {
      final result = await _loginUseCase.execute(
        email: event.email,
        password: event.password,
        type: event.type,
      );

      if (result.isSuccess) {
        final (isSuccess, msg) = await _userRepository.signInOrRegister(result.valueOrNull!);
        if (isSuccess) {
          emit(LoginSuccess(user: result.valueOrNull!, message: 'Inicio de sesión exitoso'));
        } else {
          emit(LoginError(msg));
        }
      } else {
        emit(LoginError(result.errorMessage!));
      }
    } catch (e) {
      emit(LoginError('Error inesperado: $e'));
    }
  }

  void _onRegisterRequested(RegisterRequested event, Emitter<LoginState> emit) async {
    emit(const LoginLoading());

    try {
      final result = await _registerUseCase.execute(
        email: event.email,
        password: event.password,
        name: event.name,
      );

      if (result.isSuccess) {
        emit(RegisterSuccess(user: result.valueOrNull!, message: 'Registro exitoso'));
      } else {
        emit(LoginError(result.errorMessage!));
      }
    } catch (e) {
      emit(LoginError('Error inesperado: $e'));
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<LoginState> emit) async {
    emit(const LoginLoading());

    try {
      final result = await _logoutUseCase.execute();

      if (result.isSuccess) {
        emit(const LogoutSuccess('Sesión cerrada exitosamente'));
      } else {
        emit(LoginError(result.errorMessage!));
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
        emit(LoginError(result.errorMessage!));
      }
    } catch (e) {
      emit(LoginError('Error inesperado: $e'));
    }
  }

  void _onLoginErrorCleared(LoginErrorCleared event, Emitter<LoginState> emit) {
    emit(const LoginInitial());
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
