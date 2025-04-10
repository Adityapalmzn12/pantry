import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class ItemModel extends Equatable {
  final String id;
  final String folderId;
  final String name;
  final DateTime expirationDate;
  final int quantity;
  final bool isPinned;
  final bool isTemplate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ItemModel({
    required this.id,
    required this.folderId,
    required this.name,
    required this.expirationDate,
    required this.quantity,
    required this.isPinned,
    required this.isTemplate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String? ?? uuid.v4(),
      folderId: json['folderId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      expirationDate: DateTime.tryParse(json['expirationDate'] as String? ?? '') ?? DateTime.now(),
      quantity: json['quantity'] is int
          ? json['quantity'] as int
          : int.tryParse(json['quantity'].toString()) ?? 0,
      isPinned: json['isPinned'] as bool? ?? false,
      isTemplate: json['isTemplate'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'folderId': folderId,
      'name': name,
      'expirationDate': expirationDate.toIso8601String(),
      'quantity': quantity,
      'isPinned': isPinned,
      'isTemplate': isTemplate,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ItemModel copyWith({
    String? id,
    String? folderId,
    String? name,
    DateTime? expirationDate,
    int? quantity,
    bool? isPinned,
    bool? isTemplate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      name: name ?? this.name,
      expirationDate: expirationDate ?? this.expirationDate,
      quantity: quantity ?? this.quantity,
      isPinned: isPinned ?? this.isPinned,
      isTemplate: isTemplate ?? this.isTemplate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    folderId,
    name,
    expirationDate,
    quantity,
    isPinned,
    isTemplate,
    createdAt,
    updatedAt,
  ];
}
