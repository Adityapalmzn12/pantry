import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/note.dart';

class NotesRepository {
  static const _key = 'notes';

  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => Note.fromJson(e)).toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(notes.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }
}
