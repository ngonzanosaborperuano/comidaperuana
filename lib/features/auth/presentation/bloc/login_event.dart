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
