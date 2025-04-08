import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/end_module_repository.dart';
import 'end_module_event.dart';
import 'end_module_state.dart';

class EndModuleBloc extends Bloc<EndModuleEvent, EndModuleState> {
  final EndModuleRepository repository;

  EndModuleBloc(this.repository) : super(EndModuleState.initial()) {
    on<LoadEndModules>((event, emit) {
      final items = repository.getItems();
      emit(state.copyWith(items: items, isLoading: false));
    });

    on<AddEndModuleItem>((event, emit) {
      repository.addItem(event.item);
      final items = repository.getItems();
      emit(state.copyWith(items: items));
    });
  }
}
