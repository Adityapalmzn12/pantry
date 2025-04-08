import 'package:flutter/material.dart';
import '../presentation/pages/anchored/anchored_page.dart';
import '../presentation/pages/end_module/end_module_page.dart';
import '../presentation/pages/item/item_page.dart';
import '../presentation/pages/notes/notes_page.dart';
import '../presentation/pages/template_module/template_module_page.dart';

class AppRoutes {
  static const String initialRoute = anchored;
  static const String anchored = '/anchored';
  static const String endModule = '/end_module';
  static const String item = '/item';
  static const String notes = '/notes';
  static const String templateModule = '/template_module';

  static Map<String, WidgetBuilder> routes = {
    anchored: (context) => const AnchoredPage(),
    endModule: (context) => const EndModulePage(),
    item: (context) => const ItemPage(),
    notes: (context) => const NotesPage(),
    templateModule: (context) => const TemplateModulePage(),
  };
}
