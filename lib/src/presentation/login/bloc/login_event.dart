import 'package:equatable/equatable.dart' show Equatable;

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends LoginEvent {
  final String email;
  final String password;
  final int type;

  const LoginRequested({required this.email, required this.password, required this.type});

  @override
  List<Object?> get props => [email, password, type];
}

class RegisterRequested extends LoginEvent {
  final String email;
  final String password;
  final String? name;

  const RegisterRequested({required this.email, required this.password, this.name});

  @override
  List<Object?> get props => [email, password, name];
}

class LogoutRequested extends LoginEvent {}
