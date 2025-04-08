import 'package:uuid/uuid.dart';

class TemplateModuleItem {
  final String id;
  final String title;
  final String description;

  TemplateModuleItem({
    String? id,
    required this.title,
    required this.description,
  }) : id = id ?? const Uuid().v4();
}
