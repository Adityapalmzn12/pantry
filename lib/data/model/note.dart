import 'package:uuid/uuid.dart';

final Uuid uuid = Uuid();

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    String? id,
    required this.title,
    required this.content,
    DateTime? createdAt,
  })  : id = id ?? uuid.v4(),
        createdAt = createdAt ?? DateTime.now();

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
