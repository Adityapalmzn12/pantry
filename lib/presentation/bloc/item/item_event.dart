import '../../../data/model/item.dart';


abstract class ItemEvent {}

class LoadItems extends ItemEvent {}

class AddItem extends ItemEvent {
  final ItemModel item;

  AddItem(this.item);
}

class EditItem extends ItemEvent {
  final ItemModel item;

  EditItem(this.item);
}

class DeleteItem extends ItemEvent {
  final String id;

  DeleteItem(this.id);
}

