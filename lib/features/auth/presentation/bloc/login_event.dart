part of 'login_bloc.dart';

/// Base class for all login-related events.
///
/// All events that trigger state changes in the login flow must extend this class.
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered when user requests to login with email and password.
class LoginRequested extends LoginEvent {
  final String email;
  final String password;
  final int type;

  const LoginRequested({required this.email, required this.password, required this.type});

  @override
  List<Object?> get props => [email, password, type];
}

/// Event triggered when user requests to register a new account.
class RegisterRequested extends LoginEvent {
  final String email;
  final String password;
  final String? name;

  const RegisterRequested({required this.email, required this.password, this.name});

  @override
  List<Object?> get props => [email, password, name];
}

/// Event triggered when user requests to logout.
class LogoutRequested extends LoginEvent {
  const LogoutRequested();
}

/// Event triggered when user requests to recover credentials via email.
class RecoverCredentialRequested extends LoginEvent {
  final String email;

  const RecoverCredentialRequested(this.email);

  @override
  List<Object?> get props => [email];
}

/// Event triggered to clear any login errors from the state.
class LoginErrorCleared extends LoginEvent {
  const LoginErrorCleared();
}

/// Event triggered to toggle password visibility in the login form.
class PasswordVisibilityToggled extends LoginEvent {
  const PasswordVisibilityToggled();
}

/// Event triggered when email field value changes.
class EmailChanged extends LoginEvent {
  final String email;

  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

/// Event triggered when password field value changes.
class PasswordChanged extends LoginEvent {
  final String password;

  const PasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

/// Event triggered to validate the form fields.
class FormValidated extends LoginEvent {
  const FormValidated();
}

/// Event triggered when the login button is pressed.
///
/// This event triggers the login flow by validating the provided email and password
/// and proceeding with login if validation passes.
class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  const LoginButtonPressed({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event triggered when the recover password button is pressed.
///
/// This event checks if there's an email in the current form state.
/// If email exists, it directly requests credential recovery.
/// Otherwise, it emits a state indicating that a dialog should be shown.
class RecoverPasswordButtonPressed extends LoginEvent {
  const RecoverPasswordButtonPressed();
}
