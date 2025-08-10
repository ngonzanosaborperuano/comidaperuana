import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class PagesEvent extends Equatable {
  const PagesEvent();

  @override
  List<Object?> get props => [];
}

class PageChanged extends PagesEvent {
  final int page;
  const PageChanged(this.page);

  @override
  List<Object?> get props => [page];
}

// States
abstract class PagesState extends Equatable {
  const PagesState();

  @override
  List<Object?> get props => [];
}

class PagesInitial extends PagesState {}

class PagesLoaded extends PagesState {
  final int selectedPage;
  const PagesLoaded(this.selectedPage);

  @override
  List<Object?> get props => [selectedPage];
}

// BLoC
class PagesBloc extends Bloc<PagesEvent, PagesState> {
  PagesBloc() : super(PagesInitial()) {
    on<PageChanged>(_onPageChanged);

    // Inicializar con la página 0
    add(const PageChanged(0));
  }

  void _onPageChanged(PageChanged event, Emitter<PagesState> emit) {
    emit(PagesLoaded(event.page));
  }
}
