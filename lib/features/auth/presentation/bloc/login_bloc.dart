import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goncook/core/generics/value_objects/email.dart';
import 'package:goncook/core/generics/value_objects/password.dart';
import 'package:goncook/features/auth/data/models/auth_model.dart';
import 'package:goncook/features/auth/domain/repositories/i_user_repository.dart';
import 'package:goncook/features/auth/domain/usecases/auth_usecase.dart';
import 'package:goncook/features/auth/domain/usecases/logout_usecase.dart';

part 'form_mixin.dart';
part 'login_event.dart';
part 'login_state.dart';

/// Mixin que concentra el estado y la validación del formulario de login.
///
/// Mantiene la lógica de entradas, errores y visibilidad de contraseña fuera
/// del flujo principal de autenticación para que `LoginBloc` se enfoque en
/// iniciar y cerrar sesión.

/// BLoC responsible for managing login, registration, logout, and credential recovery flows.
///
/// Handles authentication operations including:
/// - User login with email and password
/// - User registration
/// - User logout
/// - Credential recovery via email
/// - Form validation and password visibility toggling
class LoginBloc extends Bloc<LoginEvent, LoginState> with LoginFormMixin {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final IUserRepository _userRepository;

  LoginBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required IUserRepository userRepository,
  }) : _loginUseCase = loginUseCase,
       _logoutUseCase = logoutUseCase,
       _userRepository = userRepository,
       super(const LoginFormState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<PasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<FormValidated>(_onFormValidated);
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<RecoverCredentialRequested>(_onRecoverCredentialRequested);
    on<LoginErrorCleared>(_onLoginErrorCleared);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<LoginState> emit) async {
    try {
      emit(const LoginProcessState(isLoading: true));

      // Firebase login
      final result = await _loginUseCase.execute(
        email: event.email,
        password: event.password,
        type: event.type,
      );

      if (result.isSuccess) {
        // API login/registration
        final (isSuccess, errorApi) = await _userRepository.signInOrRegister(result.valueOrNull!);
        if (isSuccess) {
          emit(
            LoginSuccess(
              isSuccess: true,
              user: result.valueOrNull!,
              message: 'Inicio de sesión exitoso',
            ),
          );
          // No emitir LoginProcessState después de LoginSuccess
          // El LoginSuccess ya indica que el proceso terminó exitosamente
          return;
        } else {
          emit(
            LoginError(errorApi.isNotEmpty ? errorApi : 'Error al iniciar sesión', hasError: true),
          );
          // No emitir LoginProcessState después de LoginError
          // El LoginError ya indica que el proceso terminó con error
          return;
        }
      } else {
        emit(
          LoginError(
            hasError: true,
            result.errorMessage?.isNotEmpty == true
                ? result.errorMessage!
                : 'Error de autenticación',
          ),
        );
        // No emitir LoginProcessState después de LoginError
        return;
      }
    } catch (e) {
      emit(LoginError('Error inesperado: $e', hasError: true));
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<LoginState> emit) async {
    emit(const LoginProcessState(isLoading: true));

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

  Future<void> _onRecoverCredentialRequested(
    RecoverCredentialRequested event,
    Emitter<LoginState> emit,
  ) async {
    try {
      final result = await _loginUseCase.executeRecoverCredential(event.email);
      if (result.isSuccess) {
        emit(
          RecoverCredentialSuccess(
            'Se envio un correo a ${event.email} con el enlace de recuperación de contraseña',
          ),
        );
      } else {
        emit(LoginError(result.errorMessage!));
      }
    } catch (e) {
      emit(LoginError('Error inesperado: $e'));
    }
  }
}
