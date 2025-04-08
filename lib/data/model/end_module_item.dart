import 'package:uuid/uuid.dart';

class EndModuleItem {
  final String id;
  final String name;
  final String detail;

  EndModuleItem({
    String? id,
    required this.name,
    required this.detail,
  }) : id = id ?? const Uuid().v4();
}
