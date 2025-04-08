import '../../../data/model/end_module_item.dart';

class EndModuleState {
  final List<EndModuleItem> items;
  final bool isLoading;

  EndModuleState({required this.items, required this.isLoading});

  factory EndModuleState.initial() => EndModuleState(items: [], isLoading: true);

  EndModuleState copyWith({
    List<EndModuleItem>? items,
    bool? isLoading,
  }) {
    return EndModuleState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
