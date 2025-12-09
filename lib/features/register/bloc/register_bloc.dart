import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goncook/features/auth/data/models/auth_model.dart';
import 'package:goncook/features/auth/domain/repositories/i_user_repository.dart';
import 'package:goncook/features/auth/domain/usecases/register_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

/// BLoC responsible for managing register usuarios.
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
      //firebase register
      final result = await _registerUseCase.execute(
        email: event.email,
        password: event.password,
        name: event.fullName,
      );

      if (result.isSuccess) {
        final user = result.valueOrNull!;
        //api register
        final rpt = await _userRepository.register(user);
        if (rpt) {
          emit(RegisterSuccess(user));
        } else {
          emit(const RegisterError('Error al registrar usuario en Backend'));
        }
      } else {
        emit(const RegisterError('Error al registrar usuario en Firebase'));
      }
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}
