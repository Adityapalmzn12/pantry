class ItemModel {
  final String id;
  final String name;
  final String? image; // For item images (nullable for folders)
  final int? quantity; // For items only, folders don't need quantity
  final String? parentId; // Null means root level
  final bool isFolder;
  final DateTime createdAt;

  ItemModel({
    required this.id,
    required this.name,
    this.image,
    this.quantity,
    this.parentId,
    required this.isFolder,
    required this.createdAt,
  });

  ItemModel copyWith({
    String? id,
    String? name,
    String? image,
    int? quantity,
    String? parentId,
    bool? isFolder,
    DateTime? createdAt,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      parentId: parentId ?? this.parentId,
      isFolder: isFolder ?? this.isFolder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String?,
      quantity: json['quantity'] as int?,
      parentId: json['parentId'] as String?,
      isFolder: json['isFolder'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'quantity': quantity,
      'parentId': parentId,
      'isFolder': isFolder,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
