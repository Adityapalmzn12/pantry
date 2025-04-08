import 'package:equatable/equatable.dart';
import '../../../data/model/anchored_item.dart';


class AnchoredState extends Equatable {
  final List<AnchoredItem> items;
  final bool isLoading;

  const AnchoredState({
    this.items = const [],
    this.isLoading = false,
  });

  AnchoredState copyWith({
    List<AnchoredItem>? items,
    bool? isLoading,
  }) {
    return AnchoredState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [items, isLoading];
}
