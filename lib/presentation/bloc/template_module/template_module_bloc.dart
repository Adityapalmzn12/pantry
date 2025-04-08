import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repository/template_module_repository.dart';
import 'template_module_event.dart';
import 'template_module_state.dart';

class TemplateModuleBloc extends Bloc<TemplateModuleEvent, TemplateModuleState> {
  final TemplateModuleRepository repository;

  TemplateModuleBloc(this.repository) : super(TemplateModuleState.initial()) {
    on<LoadTemplateModules>((event, emit) {
      final items = repository.getItems();
      emit(state.copyWith(items: items, isLoading: false));
    });

    on<AddTemplateModuleItem>((event, emit) {
      repository.addItem(event.item);
      final items = repository.getItems();
      emit(state.copyWith(items: items));
    });
  }
}
