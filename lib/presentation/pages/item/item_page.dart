import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../data/model/item/folder_model.dart';
import '../../../data/model/item/item.dart';
import '../../bloc/item/item_bloc.dart';
import '../../bloc/item/item_event.dart';
import '../../bloc/item/item_state.dart';
import 'add_item_screen.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  String? selectedFolderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Items',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<ItemBloc, ItemState>(
          builder: (context, state) {
            if (state is ItemLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.amber));
            }

            if (state is ItemError) {
              return Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            }

            if (state is ItemLoaded) {
              // Ensure there are no duplicates in folders
              final folders = _removeDuplicateFolders(state.folders);
              final items = state.items;

              // Filter items based on selected folder
              final filteredItems = selectedFolderId == null
                  ? items
                  : items.where((item) => item.folderId == selectedFolderId).toList();

              return Column(
                children: [
                  // Folders Grid
                  if (folders.isNotEmpty) ...[
                    SizedBox(
                      height: 180,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: folders.length,
                        itemBuilder: (context, index) {
                          final folder = folders[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFolderId = folder.id;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: _hexToColor(folder.colorHex),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  folder.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Items List
                  if (filteredItems.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddItemScreen(
                                    existingItem: item, // Pass the selected item
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.grey.shade900,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          item.createdAt != null
                                              ? DateFormat('dd-MM-yyyy').format(item.createdAt!)
                                              : 'dd-mm-yyyy',
                                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Decrease Button
                                        IconButton(
                                          icon: const Icon(Icons.remove, color: Colors.white),
                                          onPressed: () {
                                            if (item.quantity > 0) {
                                              context.read<ItemBloc>().add(
                                                UpdateItemQuantityEvent(
                                                  itemId: item.id,
                                                  change: -1, // Decrease by 1
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                        Text(
                                          '${item.quantity}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                        // Increase Button
                                        IconButton(
                                          icon: const Icon(Icons.add, color: Colors.white),
                                          onPressed: () {
                                            context.read<ItemBloc>().add(
                                              UpdateItemQuantityEvent(
                                                itemId: item.id,
                                                change: 1, // Increase by 1
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  // If no items and no folders
                  if (folders.isEmpty && items.isEmpty)
                    const Center(
                      child: Text(
                        'No items or folders found.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),

      // Floating action button to add new item
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemScreen()),
          );
        },
      ),
    );
  }

  // Helper method to convert hex color string to Color
  Color _hexToColor(String hex) {
    try {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) hex = 'FF$hex'; // add alpha if not provided
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return Colors.grey; // fallback color
    }
  }

  // Function to remove duplicate folders
  List<FolderModel> _removeDuplicateFolders(List<FolderModel> folders) {
    return folders.toSet().toList(); // Use Set to remove duplicates based on equality
  }
}

