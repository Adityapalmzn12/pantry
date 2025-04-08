import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/item.dart';


class ItemRepository {
  static const _key = 'items';

  Future<List<ItemModel>> getItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((e) => ItemModel.fromJson(e)).toList();
    } catch (e) {
      // If there's an error in decoding, return empty list
      return [];
    }
  }

  Future<void> saveItems(List<ItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<void> clearItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
