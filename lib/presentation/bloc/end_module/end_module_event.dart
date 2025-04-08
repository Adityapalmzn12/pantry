import '../../../data/model/end_module_item.dart';

abstract class EndModuleEvent {}

class LoadEndModules extends EndModuleEvent {}

class AddEndModuleItem extends EndModuleEvent {
  final EndModuleItem item;

  AddEndModuleItem(this.item);
}
