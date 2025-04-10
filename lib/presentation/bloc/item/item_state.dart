import '../../../data/model/item/folder_model.dart';
import '../../../data/model/item/item.dart';

abstract class ItemState {}

class ItemInitial extends ItemState {}

class ItemLoading extends ItemState {}

class ItemLoaded extends ItemState {
  final List<FolderModel> folders;
  final List<ItemModel> items;

  ItemLoaded({
    required this.folders,
    required this.items,
  });
}

class ItemError extends ItemState {
  final String message;

  ItemError(this.message);
}
