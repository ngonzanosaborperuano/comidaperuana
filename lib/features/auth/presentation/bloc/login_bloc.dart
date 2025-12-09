import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goncook/features/auth/data/models/auth_model.dart';
import 'package:goncook/features/auth/domain/repositories/i_user_repository.dart';
import 'package:goncook/features/auth/domain/usecases/auth_usecase.dart';
import 'package:goncook/features/auth/domain/usecases/logout_usecase.dart';

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
    on<RecoverPasswordButtonPressed>(_onRecoverPasswordButtonPressed);
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
        emit(const RecoverCredentialSuccess('Correo de recuperación enviado'));
      } else {
        emit(LoginError(result.errorMessage!));
      }
    } catch (e) {
      emit(LoginError('Error inesperado: $e'));
    }
  }

  void _onLoginErrorCleared(LoginErrorCleared event, Emitter<LoginState> emit) {
    final currentState = state is LoginFormState ? state as LoginFormState : const LoginFormState();
    emit(currentState.copyWith(emailError: null, passwordError: null));
  }

  void _onEmailChanged(EmailChanged event, Emitter<LoginState> emit) {
    final currentState = state is LoginFormState ? state as LoginFormState : const LoginFormState();
    final emailError = validateEmail(event.email);
    final isValid =
        emailError == null &&
        currentState.passwordError == null &&
        event.email.isNotEmpty &&
        currentState.password.isNotEmpty;

    // Solo mostrar errores si ya se intentó validar el formulario
    emit(
      currentState.copyWith(
        email: event.email,
        emailError: currentState.hasAttemptedValidation ? emailError : null,
        isValid: isValid,
      ),
    );
  }

  void _onPasswordChanged(PasswordChanged event, Emitter<LoginState> emit) {
    final currentState = state is LoginFormState ? state as LoginFormState : const LoginFormState();
    final passwordError = validatePassword(event.password);
    final isValid =
        currentState.emailError == null &&
        passwordError == null &&
        currentState.email.isNotEmpty &&
        event.password.isNotEmpty;

    // Solo mostrar errores si ya se intentó validar el formulario
    emit(
      currentState.copyWith(
        password: event.password,
        passwordError: currentState.hasAttemptedValidation ? passwordError : null,
        isValid: isValid,
      ),
    );
  }

  void _onPasswordVisibilityToggled(PasswordVisibilityToggled event, Emitter<LoginState> emit) {
    final currentState = state is LoginFormState ? state as LoginFormState : const LoginFormState();
    emit(currentState.copyWith(isPasswordVisible: !currentState.isPasswordVisible));
  }

  void _onFormValidated(FormValidated event, Emitter<LoginState> emit) {
    final currentState = state is LoginFormState ? state as LoginFormState : const LoginFormState();
    final emailError = validateEmail(currentState.email);
    final passwordError = validatePassword(currentState.password);
    final isValid =
        emailError == null &&
        passwordError == null &&
        currentState.email.isNotEmpty &&
        currentState.password.isNotEmpty;

    emit(
      currentState.copyWith(emailError: emailError, passwordError: passwordError, isValid: isValid),
    );
  }

  /// Handles the login button press event.
  ///
  /// Validates the provided email and password and proceeds with login if validation passes.
  /// Uses the provided values directly from the event.
  Future<void> _onLoginButtonPressed(LoginButtonPressed event, Emitter<LoginState> emit) async {
    // Validar los campos usando las variables del evento
    final emailError = validateEmail(event.email);
    final passwordError = validatePassword(event.password);

    // Si hay errores de validación o campos vacíos, actualizar el estado con los errores
    if (emailError != null || passwordError != null) {
      emit(
        LoginFormState(
          emailError: emailError,
          passwordError: passwordError,
          isValid: false,
          hasAttemptedValidation: true,
        ),
      );
    } else {
      // Si todo está válido, proceder directamente con el login usando los valores del evento
      emit(LoginFormState(isValid: true, email: event.email, password: event.password));
    }
  }

  Future<void> _onRecoverPasswordButtonPressed(
    RecoverPasswordButtonPressed event,
    Emitter<LoginState> emit,
  ) async {
    final currentState = state is LoginFormState ? state as LoginFormState : const LoginFormState();

    // Usar la variable del estado directamente
    if (currentState.email.isNotEmpty) {
      // Si hay email en el estado, proceder directamente con la recuperación
      await _onRecoverCredentialRequested(RecoverCredentialRequested(currentState.email), emit);
    } else {
      // Si no hay email, emitir estado para mostrar el diálogo
      emit(const RecoverPasswordDialogRequested());
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
