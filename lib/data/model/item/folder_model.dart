import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class FolderModel extends Equatable {
  final String id;
  final String name;
  final String colorHex;

  const FolderModel({
    required this.id,
    required this.name,
    required this.colorHex,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      colorHex: json['colorHex'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'colorHex': colorHex,
    };
  }

  @override
  List<Object?> get props => [id, name, colorHex];
}
