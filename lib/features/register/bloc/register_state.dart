part of 'register_bloc.dart';

// States
abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterProcessState extends RegisterState {
  final bool isLoading;
  const RegisterProcessState(this.isLoading);

  @override
  List<Object?> get props => [isLoading];
}

class RegisterSuccess extends RegisterState {
  final AuthModel user;
  const RegisterSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class RegisterError extends RegisterState {
  final String message;
  const RegisterError(this.message);

  @override
  List<Object?> get props => [message];
}
