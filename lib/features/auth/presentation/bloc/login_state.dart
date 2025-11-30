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

/// State indicating an error occurred during login operations.
class LoginError extends LoginState {
  final String message;

  const LoginError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State containing form-specific UI state for the login form.
///
/// Manages password visibility and validation errors for email and password fields.
class LoginFormState extends LoginState {
  final bool isPasswordVisible;
  final String? emailError;
  final String? passwordError;

  const LoginFormState({this.isPasswordVisible = true, this.emailError, this.passwordError});

  /// Creates a copy of this state with the given fields replaced with new values.
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
