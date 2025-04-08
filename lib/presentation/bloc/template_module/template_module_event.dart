import '../../../data/model/template_module_item.dart';

abstract class TemplateModuleEvent {}

class LoadTemplateModules extends TemplateModuleEvent {}

class AddTemplateModuleItem extends TemplateModuleEvent {
  final TemplateModuleItem item;

  AddTemplateModuleItem(this.item);
}
