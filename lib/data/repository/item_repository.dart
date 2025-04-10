import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../model/item/folder_model.dart';
import '../model/item/item.dart';

class ItemRepository {
  final String _itemKey = 'items';
  final String _folderKey = 'folders';

  final Uuid _uuid = Uuid(); // UUID instance to generate unique IDs

  // Save Item
  Future<void> saveItem(ItemModel item) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getItems();
    items.add(item);
    await prefs.setStringList(
      _itemKey,
      items.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  // Get Items with slight delay
  Future<List<ItemModel>> getItems() async {
    await Future.delayed(const Duration(milliseconds: 200)); // small delay
    final prefs = await SharedPreferences.getInstance();
    final itemsStringList = prefs.getStringList(_itemKey) ?? [];
    return itemsStringList.map((e) => ItemModel.fromJson(jsonDecode(e))).toList();
  }

  // Get Folders with slight delay
// Get Folders with slight delay and avoid duplicates when loading
  Future<List<FolderModel>> getFolders() async {
    await Future.delayed(const Duration(milliseconds: 200)); // small delay
    final prefs = await SharedPreferences.getInstance();
    final folderStringList = prefs.getStringList(_folderKey) ?? [];

    // If no stored folders, return default folders
    if (folderStringList.isEmpty) {
      final defaultFolders = getDefaultFolders();
      await saveFolders(defaultFolders, existingFolders: []);
      return defaultFolders;
    }

    final storedFolders = folderStringList
        .map((e) => FolderModel.fromJson(jsonDecode(e)))
        .toList();

    // Merge stored folders with default folders (skip if folder already exists by ID or name)
    final mergedFolders = [
      ...storedFolders, // Keep existing folders
      ...getDefaultFolders().where(
            (defaultFolder) => !storedFolders.any(
              (existingFolder) =>
          existingFolder.id == defaultFolder.id ||
              existingFolder.name.toLowerCase() == defaultFolder.name.toLowerCase(),
        ),
      ),
    ];

    // Return the merged folder list (no duplicates)
    return mergedFolders;
  }


  // Save Folders with Deduplication
  Future<void> saveFolders(List<FolderModel> newFolders, {List<FolderModel>? existingFolders}) async {
    final prefs = await SharedPreferences.getInstance();

    final currentFolders = existingFolders ?? await getFolders();

    // Deduplicate: Prevent adding folders with the same ID or name (case-insensitive)
    final mergedFolders = [
      ...currentFolders,
      ...newFolders.where((newFolder) =>
      !currentFolders.any((existingFolder) =>
      existingFolder.id == newFolder.id ||
          existingFolder.name.toLowerCase() == newFolder.name.toLowerCase())),
    ];

    // Store merged folders into SharedPreferences
    await prefs.setStringList(
      _folderKey,
      mergedFolders.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  // Default Folders
  List<FolderModel> getDefaultFolders() {
    return [
      FolderModel(id: _uuid.v4(), name: 'New Folder', colorHex: '#FFC107'), // amber
      FolderModel(id: _uuid.v4(), name: 'Mother\'s items', colorHex: '#FF5722'), // deep orange
      FolderModel(id: _uuid.v4(), name: 'My Items', colorHex: '#9C27B0'), // purple
      FolderModel(id: _uuid.v4(), name: 'Archive', colorHex: '#00BCD4'), // cyan
      FolderModel(id: _uuid.v4(), name: 'Food festival', colorHex: '#F44336'), // red
    ];
  }

  // Save a folder with an item inside it
  Future<void> saveFolderWithItem(ItemModel item, String folderName) async {
    final prefs = await SharedPreferences.getInstance();
    final folders = await getFolders();

    // Check if the folder already exists
    FolderModel? existingFolder = folders.firstWhere(
          (folder) => folder.name.toLowerCase() == folderName.toLowerCase(),
      orElse: () => FolderModel(id: _uuid.v4(), name: folderName, colorHex: _generateRandomColor()), // Create a new folder if not found
    );

    // If the folder is newly created, add it to the list
    if (!folders.any((folder) => folder.id == existingFolder.id)) {
      folders.add(existingFolder);
      await prefs.setStringList(
        _folderKey,
        folders.map((e) => jsonEncode(e.toJson())).toList(),
      );
    }

    // Create a new item with the updated folderId using copyWith (since folderId is final)
    final updatedItem = item.copyWith(folderId: existingFolder.id);

    // Save the item with the updated folderId
    await saveItem(updatedItem);
  }

  // Delete Item
  Future<void> deleteItem(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await getItems();

    // Remove the item with the given itemId
    items.removeWhere((item) => item.id == itemId);

    // Save the updated list of items back to shared preferences
    await prefs.setStringList(
      _itemKey,
      items.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  // Helper function to generate a random color (hex code)
  String _generateRandomColor() {
    final random = Random();
    final color = Color((random.nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    return '#${color.value.toRadixString(16).substring(2, 8).toUpperCase()}';
  }
}
