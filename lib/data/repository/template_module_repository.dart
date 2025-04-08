import '../model/template_module_item.dart';

class TemplateModuleRepository {
  final List<TemplateModuleItem> _items = [];

  List<TemplateModuleItem> getItems() => List.unmodifiable(_items);

  void addItem(TemplateModuleItem item) {
    _items.add(item);
  }
}
