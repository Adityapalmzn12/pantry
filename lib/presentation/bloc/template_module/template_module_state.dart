import '../../../data/model/template_module_item.dart';

class TemplateModuleState {
  final List<TemplateModuleItem> items;
  final bool isLoading;

  TemplateModuleState({required this.items, required this.isLoading});

  factory TemplateModuleState.initial() => TemplateModuleState(items: [], isLoading: true);

  TemplateModuleState copyWith({
    List<TemplateModuleItem>? items,
    bool? isLoading,
  }) {
    return TemplateModuleState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
