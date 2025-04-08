import 'package:equatable/equatable.dart';

import '../../../data/model/anchored_item.dart';


abstract class AnchoredEvent extends Equatable {
  const AnchoredEvent();

  @override
  List<Object> get props => [];
}

class LoadAnchoredItems extends AnchoredEvent {}

class AddAnchoredItem extends AnchoredEvent {
  final AnchoredItem item;

  const AddAnchoredItem(this.item);

  @override
  List<Object> get props => [item];
}
