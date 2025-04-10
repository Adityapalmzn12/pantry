// item_event.dart

import '../../../data/model/item/folder_model.dart';
import '../../../data/model/item/item.dart';

abstract class ItemEvent {}

class LoadFoldersAndItemsEvent extends ItemEvent {}

class AddFolderEvent extends ItemEvent {
  final FolderModel folder;

  AddFolderEvent(this.folder);
}

class AddItemEvent extends ItemEvent {
  final ItemModel item;

  AddItemEvent(this.item);
}

class UpdateItemEvent extends ItemEvent {
  final ItemModel item;

  UpdateItemEvent(this.item);
}

class UpdateItemQuantityEvent extends ItemEvent {
  final String itemId;
  final int change;

  UpdateItemQuantityEvent({
    required this.itemId,
    required this.change,
  });
}

class DeleteItemEvent extends ItemEvent {
  final String itemId;

  DeleteItemEvent(this.itemId);
}

