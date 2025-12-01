part of 'login_bloc.dart';

/// Base class for all login-related states.
///
/// All states in the login flow must extend this class and implement Equatable
/// for proper state comparison in BLoC.
abstract class LoginState extends Equatable {
  const LoginState();

  /// Returns true if the recover password dialog should be shown.
  bool get shouldShowRecoverPasswordDialog => false;

  /// Returns the email value from the form state, or empty string if not available.
  String get email => '';

  /// Returns the password value from the form state, or empty string if not available.
  String get password => '';

  /// Returns the email error from the form state, or null if not available.
  String? get emailError => null;

  /// Returns the password error from the form state, or null if not available.
  String? get passwordError => null;

  /// cuando la api devuelve una respuesta de error, se debe mostrar en el estado
  String? get errorMessage => null;

  @override
  List<Object?> get props => [emailError, passwordError, errorMessage];
}

/// Initial state when the login bloc is first created.
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// State indicating that a login operation is in progress.
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// State indicating successful login with authenticated user data.
class LoginSuccess extends LoginState {
  final AuthUser user;
  final String message;

  const LoginSuccess({required this.user, required this.message});

  @override
  List<Object?> get props => [user, message];
}

/// State indicating successful user registration.
class RegisterSuccess extends LoginState {
  final AuthUser user;
  final String message;

  const RegisterSuccess({required this.user, required this.message});

  @override
  List<Object?> get props => [user, message];
}

/// State indicating successful logout.
class LogoutSuccess extends LoginState {
  final String message;

  const LogoutSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// State indicating successful credential recovery email sent.
class RecoverCredentialSuccess extends LoginState {
  final String message;

  const RecoverCredentialSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// State indicating that the recover password dialog should be shown.
///
/// This state is emitted when the user requests password recovery
/// but there's no email in the current form state.
class RecoverPasswordDialogRequested extends LoginState {
  const RecoverPasswordDialogRequested();

  @override
  bool get shouldShowRecoverPasswordDialog => true;
}

/// State indicating an error occurred during login operations.
class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State containing form-specific UI state for the login form.
///
/// Manages password visibility, form field values, and validation errors for email and password fields.
class LoginFormState extends LoginState {
  @override
  final String email;
  @override
  final String password;
  final bool isPasswordVisible;
  @override
  final String? emailError;
  @override
  final String? passwordError;
  final bool isValid;
  final bool hasAttemptedValidation;
  @override
  final String? errorMessage;
  const LoginFormState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = true,
    this.emailError,
    this.passwordError,
    this.isValid = false,
    this.hasAttemptedValidation = false,
    this.errorMessage,
  });

  /// Creates a copy of this state with the given fields replaced with new values.
  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    String? emailError,
    String? passwordError,
    bool? isValid,
    bool? hasAttemptedValidation,
    String? errorMessage,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
      hasAttemptedValidation: hasAttemptedValidation ?? this.hasAttemptedValidation,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    isPasswordVisible,
    emailError,
    passwordError,
    isValid,
    hasAttemptedValidation,
    errorMessage,
  ];
}
