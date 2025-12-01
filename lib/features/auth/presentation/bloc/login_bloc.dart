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
       super(const LoginFormState()) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<PasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<FormValidated>(_onFormValidated);
    on<LoginButtonPressed>(_onLoginButtonPressed);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<RecoverPasswordButtonPressed>(_onRecoverPasswordButtonPressed);
    on<RecoverCredentialRequested>(_onRecoverCredentialRequested);
    on<LoginErrorCleared>(_onLoginErrorCleared);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<LoginState> emit) async {
    // Obtener el estado actual, asegurándose de que es LoginFormState
    final currentState = state is LoginFormState ? state as LoginFormState : const LoginFormState();

    // Si todo está válido, proceder con el login
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
          // En caso de error, restaurar el estado del formulario con el error
          emit(
            currentState.copyWith(email: event.email, password: event.password, emailError: msg),
          );
        }
      } else {
        // En caso de error, restaurar el estado del formulario con el error
        emit(
          currentState.copyWith(
            email: event.email,
            password: event.password,
            errorMessage: result.errorMessage,
          ),
        );
      }
    } catch (e) {
      // En caso de excepción, restaurar el estado del formulario con el error
      emit(
        currentState.copyWith(
          email: event.email,
          password: event.password,
          emailError: 'Error inesperado: $e',
        ),
      );
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
    // Obtener el estado actual
    final currentState = state is LoginFormState ? state as LoginFormState : const LoginFormState();

    // Validar los campos usando las variables del evento
    final emailError = validateEmail(event.email);
    final passwordError = validatePassword(event.password);

    // Si hay errores de validación o campos vacíos, actualizar el estado con los errores
    if (emailError != null ||
        passwordError != null ||
        event.email.isEmpty ||
        event.password.isEmpty) {
      emit(
        currentState.copyWith(
          emailError: emailError,
          passwordError: passwordError,
          isValid: false,
          hasAttemptedValidation: true,
        ),
      );
    } else {
      // Si todo está válido, proceder directamente con el login usando los valores del evento
      await _onLoginRequested(
        LoginRequested(
          email: event.email,
          password: event.password,
          type: 1, // LoginWith.withUserPassword
        ),
        emit,
      );
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
