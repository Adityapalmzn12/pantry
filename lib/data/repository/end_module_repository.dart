import '../model/end_module_item.dart';

class EndModuleRepository {
  final List<EndModuleItem> _items = [];

  List<EndModuleItem> getItems() => List.unmodifiable(_items);

  void addItem(EndModuleItem item) {
    _items.add(item);
  }
}
