import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goncook/features/auth/domain/auth/repositories/i_user_repository.dart';

// Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeInitialized extends HomeEvent {}

class HomeSearchCompleted extends HomeEvent {
  final bool? isPending;
  const HomeSearchCompleted(this.isPending);

  @override
  List<Object?> get props => [isPending];
}

class HomeInsertTask extends HomeEvent {
  final String title;
  final String body;
  const HomeInsertTask({required this.title, required this.body});

  @override
  List<Object?> get props => [title, body];
}

class HomeUpdateTask extends HomeEvent {
  final int id;
  final String title;
  final String body;
  const HomeUpdateTask({required this.id, required this.title, required this.body});

  @override
  List<Object?> get props => [id, title, body];
}

class HomeDeleteTask extends HomeEvent {
  final int id;
  const HomeDeleteTask(this.id);

  @override
  List<Object?> get props => [id];
}

class HomeSearchTask extends HomeEvent {
  final String title;
  const HomeSearchTask(this.title);

  @override
  List<Object?> get props => [title];
}

// States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  //final List<TaskModel> listTask;
  //final List<TaskModel> listTaskDashboard;
  //final bool? isPending;
  //const HomeLoaded({required this.listTask, required this.listTaskDashboard, this.isPending});
  //
  //@override
  //List<Object?> get props => [listTask, listTaskDashboard, isPending];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}

class HomeTaskOperationSuccess extends HomeState {
  final bool success;
  const HomeTaskOperationSuccess(this.success);

  @override
  List<Object?> get props => [success];
}

// BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({required IUserRepository userRepository})
    : _userRepository = userRepository,
      super(HomeInitial()) {
    on<HomeInitialized>(_onHomeInitialized);
    on<HomeSearchCompleted>(_onHomeSearchCompleted);
    /*
    on<HomeInsertTask>(_onHomeInsertTask);
    on<HomeUpdateTask>(_onHomeUpdateTask);
    on<HomeDeleteTask>(_onHomeDeleteTask);
    on<HomeSearchTask>(_onHomeSearchTask);
*/
    // Inicializar automáticamente
    add(HomeInitialized());
  }

  final IUserRepository _userRepository;
  Timer? _debounce;

  void _onHomeInitialized(HomeInitialized event, Emitter<HomeState> emit) async {
    // emit(HomeLoading());
    try {
      //final listTask = <TaskModel>[]; //await _taskRepository.getListTask();
      //final listTaskDashboard = listTask;
      emit(HomeLoaded());
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void _onHomeSearchCompleted(HomeSearchCompleted event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      emit(HomeLoading());
      try {} catch (e) {
        emit(HomeError(e.toString()));
      }
    }
  }

  /*
  void _onHomeInsertTask(HomeInsertTask event, Emitter<HomeState> emit) async {
    try {
      final secureStorageService = SecurityStorageService();
      final user = await secureStorageService.loadCredentials();
      final taskModel = TaskModel(userId: user!.id!, title: event.title, body: event.body);
      final result = await _userRepository.register(user);
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void _onHomeUpdateTask(HomeUpdateTask event, Emitter<HomeState> emit) async {
    try {
      final secureStorageService = SecurityStorageService();
      final user = await secureStorageService.loadCredentials();
      final taskModel = TaskModel(
        userId: user!.id!,
        id: event.id,
        title: event.title,
        body: event.body,
      );
      final result = await _userRepository.updateUser(user);
      emit(HomeTaskOperationSuccess(result));

      // Recargar la lista después de actualizar
      if (result) {
        add(HomeInitialized());
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void _onHomeDeleteTask(HomeDeleteTask event, Emitter<HomeState> emit) async {
    try {
      final result = await _userRepository.delete(event.id);
      emit(HomeTaskOperationSuccess(result));

      // Recargar la lista después de eliminar
      if (result) {
        add(HomeInitialized());
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void _onHomeSearchTask(HomeSearchTask event, Emitter<HomeState> emit) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (state is HomeLoaded) {
        try {
          final listTask = await _userRepository.searchUser(
            tabla: TablaStorage.task,
            valor: event.title,
          );
          emit(
            HomeLoaded(
              listTask: listTask,
              listTaskDashboard: (state as HomeLoaded).listTaskDashboard,
              isPending: (state as HomeLoaded).isPending,
            ),
          );
        } catch (e) {
          emit(HomeError(e.toString()));
        }
      }
    });
  }
*/
}
