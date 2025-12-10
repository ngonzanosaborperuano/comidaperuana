import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goncook/features/auth/data/models/auth_model.dart';
import 'package:goncook/features/auth/domain/repositories/i_user_repository.dart';
import 'package:goncook/features/auth/domain/usecases/register_usecase.dart';
import 'package:logging/logging.dart';

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
  final _logger = Logger('RegisterBloc');

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<RegisterState> emit) async {
    emit(const RegisterProcessState(true));
    await Future.delayed(const Duration(seconds: 5));
    emit(const RegisterProcessState(false));

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
          _logger.info('Usuario registrado exitosamente: ${user.email}');
          emit(RegisterSuccess(user));
          return;
        } else {
          _logger.severe('Error al registrar usuario en Backend');
          emit(const RegisterError('Error al registrar usuario en Backend'));
          return;
        }
      } else {
        _logger.severe('Error al registrar usuario en Firebase: ${result.errorMessage}');
        emit(
          RegisterError(
            result.errorMessage?.isNotEmpty == true
                ? 'Error al registrar usuario en Firebase: ${result.errorMessage}'
                : 'Error al registrar usuario en Firebase',
          ),
        );
        return;
      }
    } catch (e, stackTrace) {
      _logger.severe('Error inesperado al registrar usuario: $e', e, stackTrace);
      emit(RegisterError('Error inesperado: $e'));
    }
  }
}
