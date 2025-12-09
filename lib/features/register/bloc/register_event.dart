part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterRequested extends RegisterEvent {
  final String email;
  final String password;
  final String? fullName;
  const RegisterRequested({required this.email, required this.password, this.fullName});

  @override
  List<Object?> get props => [email, password, fullName];
}
