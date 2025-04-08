import '../../../data/model/item.dart';

class ItemState {
  final List<ItemModel> items;
  final bool isLoading;

  ItemState({required this.items, required this.isLoading});

  factory ItemState.initial() => ItemState(items: [], isLoading: true);

  ItemState copyWith({List<ItemModel>? items, bool? isLoading}) {
    return ItemState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
