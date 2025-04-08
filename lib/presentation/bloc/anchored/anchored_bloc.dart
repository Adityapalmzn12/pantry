import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/anchored_item.dart';
import '../../../data/repository/anchored_repository.dart';
import 'anchored_event.dart';
import 'anchored_state.dart';

class AnchoredBloc extends Bloc<AnchoredEvent, AnchoredState> {
  final AnchoredRepository repository;

  AnchoredBloc(this.repository) : super(const AnchoredState()) {
    on<LoadAnchoredItems>(_onLoadItems);
    on<AddAnchoredItem>(_onAddItem);
  }

  Future<void> _onLoadItems(
      LoadAnchoredItems event, Emitter<AnchoredState> emit) async {
    emit(state.copyWith(isLoading: true));
    final items = await repository.fetchItems();
    emit(state.copyWith(items: items, isLoading: false));
  }

  Future<void> _onAddItem(
      AddAnchoredItem event, Emitter<AnchoredState> emit) async {
    final updatedItems = List<AnchoredItem>.from(state.items)..add(event.item);
    await repository.saveItems(updatedItems);
    emit(state.copyWith(items: updatedItems));
  }
}
