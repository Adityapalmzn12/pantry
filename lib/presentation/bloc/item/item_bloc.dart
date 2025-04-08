import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/item.dart';
import 'item_event.dart';
import 'item_state.dart';
import '../../../data/repository/item_repository.dart';


class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ItemRepository repository;

  ItemBloc(this.repository) : super(ItemState.initial()) {
    on<LoadItems>(_onLoadItems);
    on<AddItem>(_onAddItem);
    on<EditItem>(_onEditItem);
    on<DeleteItem>(_onDeleteItem);
  }

  Future<void> _onLoadItems(LoadItems event, Emitter<ItemState> emit) async {
    emit(state.copyWith(isLoading: true));
    final items = await repository.getItems();
    emit(state.copyWith(items: items, isLoading: false));
  }

  Future<void> _onAddItem(AddItem event, Emitter<ItemState> emit) async {
    final updatedList = List<ItemModel>.from(state.items)..add(event.item);
    await repository.saveItems(updatedList);
    emit(state.copyWith(items: updatedList));
  }

  Future<void> _onEditItem(EditItem event, Emitter<ItemState> emit) async {
    final updatedList = state.items.map((item) {
      return item.id == event.item.id ? event.item : item;
    }).toList();

    await repository.saveItems(updatedList);
    emit(state.copyWith(items: updatedList));
  }

  Future<void> _onDeleteItem(DeleteItem event, Emitter<ItemState> emit) async {
    final updatedList = List<ItemModel>.from(state.items)
      ..removeWhere((item) => item.id == event.id);

    await repository.saveItems(updatedList);
    emit(state.copyWith(items: updatedList));
  }
}
