part of 'login_bloc.dart';

/// Base class for all login-related states.
///
/// All states in the login flow must extend this class and implement Equatable
/// for proper state comparison in BLoC.
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// State containing form-specific UI state for the login form.
///
/// Manages password visibility, form field values, and validation errors for email and password fields.
class LoginFormState extends LoginState {
  final bool isPasswordVisible;
  final bool isValid;
  final bool hasAttemptedValidation;
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;

  const LoginFormState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = true,
    this.emailError,
    this.passwordError,
    this.isValid = false,
    this.hasAttemptedValidation = false,
  });

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    String? emailError,
    String? passwordError,
    bool? isValid,
    bool? hasAttemptedValidation,
    bool? isValidate,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      emailError: emailError ?? this.emailError,
      passwordError: passwordError ?? this.passwordError,
      isValid: isValid ?? this.isValid,
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
  ];
}

/// State indicating that the login process is in progress.
class LoginProcessState extends LoginState {
  final bool isLoading;

  const LoginProcessState({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

/// State indicating that the login operation was successful.
class LoginSuccess extends LoginState {
  final AuthModel? user;
  final String? message;
  final bool isSuccess;
  const LoginSuccess({this.user, this.message, this.isSuccess = true});

  @override
  List<Object?> get props => [user, message, isSuccess];

  LoginSuccess copyWith({AuthModel? user, String? message, bool? isSuccess}) {
    return LoginSuccess(
      user: user ?? this.user,
      message: message ?? this.message,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

/// State indicating an error occurred during login operations.
class LoginError extends LoginState {
  final String message;
  final bool hasError;

  const LoginError(this.message, {this.hasError = true});

  @override
  List<Object?> get props => [message, hasError];

  LoginError copyWith({String? message, bool? hasError = true}) {
    return LoginError(message ?? this.message, hasError: hasError ?? true);
  }
}

/***********************************************************/
/***********************************************************/
/***********************************************************/
/// State indicating successful user registration.
class RegisterSuccess extends LoginState {
  final AuthModel user;
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

  /// Returns true to indicate the recover password dialog should be shown.
  bool get shouldShowRecoverPasswordDialog => true;
}
