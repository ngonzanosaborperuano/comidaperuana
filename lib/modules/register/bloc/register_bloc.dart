import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:recetasperuanas/application/auth/use_cases/register_use_case.dart';
import 'package:recetasperuanas/core/auth/models/auth_user.dart';
import 'package:recetasperuanas/domain/auth/repositories/i_user_repository.dart';

// Events
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

// States
abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final AuthUser user;
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

// Bloc
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required RegisterUseCase registerUseCase, required IUserRepository userRepository})
    : _registerUseCase = registerUseCase,
      _userRepository = userRepository,
      super(RegisterInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
  }

  final RegisterUseCase _registerUseCase;
  final IUserRepository _userRepository;

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    try {
      final result = await _registerUseCase.execute(
        email: event.email,
        password: event.password,
        name: event.fullName,
      );

      if (result.isSuccess) {
        final user = result.successValue!;
        await _userRepository.register(user);
        emit(RegisterSuccess(user));
      } else {
        emit(RegisterError(result.failureValue!.message));
      }
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}
