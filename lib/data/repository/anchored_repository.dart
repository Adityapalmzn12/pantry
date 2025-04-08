import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/anchored_item.dart';



class AnchoredRepository {
  static const _storageKey = 'anchored_items';

  Future<List<AnchoredItem>> fetchItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    return decoded.map((item) => AnchoredItem.fromMap(item)).toList();
  }

  Future<void> saveItems(List<AnchoredItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(items.map((e) => e.toMap()).toList());
    await prefs.setString(_storageKey, jsonString);
  }
}
