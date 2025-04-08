class AnchoredItem {
  final String id;
  final String title;
  final String description;

  AnchoredItem({
    required this.id,
    required this.title,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  factory AnchoredItem.fromMap(Map<String, dynamic> map) {
    return AnchoredItem(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }
}
