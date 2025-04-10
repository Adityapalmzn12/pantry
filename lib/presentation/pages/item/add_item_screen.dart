import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../data/model/item/folder_model.dart';
import '../../../data/model/item/item.dart';
import '../../bloc/item/item_bloc.dart';
import '../../bloc/item/item_event.dart';
import '../../bloc/item/item_state.dart';

class AddItemScreen extends StatefulWidget {
  final ItemModel? existingItem; // Optional parameter for pre-filling data

  AddItemScreen({this.existingItem});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  String selectedFolder = 'My items';
  String? selectedFolderId;
  int quantity = 1;
  DateTime? selectedDate;
  bool isPinned = false;
  bool isTemplate = false;
  final TextEditingController nameController = TextEditingController();
  final uuid = Uuid();

  @override
  void initState() {
    super.initState();
    // If an existing item is passed, pre-fill the form fields
    if (widget.existingItem != null) {
      final existingItem = widget.existingItem!;
      nameController.text = existingItem.name;
      selectedFolder = existingItem.name; // Set folder to item name
      selectedFolderId = existingItem.folderId;
      quantity = existingItem.quantity;
      selectedDate = existingItem.expirationDate;
      isPinned = existingItem.isPinned;
      isTemplate = existingItem.isTemplate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header row with optional delete button
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    const Text(
                      'Add Item',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        if (widget.existingItem != null) {
                          context.read<ItemBloc>().add(DeleteItemEvent(widget.existingItem!.id));
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),

                // Item name field
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter item name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Pin item checkbox
                Row(
                  children: [
                    Checkbox(
                      value: isPinned,
                      onChanged: (value) => setState(() => isPinned = value ?? false),
                    ),
                    const Text('Pin this item to "Anchored"'),
                  ],
                ),
                const SizedBox(height: 8),

                // Folder selection
                // Folder selection widget
                BlocBuilder<ItemBloc, ItemState>(
                  builder: (context, state) {
                    if (state is ItemLoaded) {
                      final folders = state.folders;

                      // Ensure "My items" is selected by default if no folder is selected
                      if (selectedFolder == null || selectedFolder.isEmpty) {
                        selectedFolder = 'My items';  // Default folder
                      }

                      return GestureDetector(
                        onTap: () {
                          // Open the bottom sheet to select a folder
                          _showFolderSelection(context, folders);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.folder_copy_outlined),
                              const SizedBox(width: 8),
                              Text(selectedFolder),  // Display the selected folder name
                              const Spacer(),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),


                const SizedBox(height: 16),

                // Expiration date
                ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                    selectedDate == null
                        ? 'Set expiration date'
                        : '${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}',
                  ),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),

                // Quantity selector
                Row(
                  children: [
                    const Text('Quantity:'),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: quantity > 1
                          ? () => setState(() => quantity--)
                          : null,
                    ),
                    Text(quantity.toString()),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => quantity++),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Template checkbox
                Row(
                  children: [
                    Checkbox(
                      value: isTemplate,
                      onChanged: (value) => setState(() => isTemplate = value ?? false),
                    ),
                    const Text('Save as template'),
                  ],
                ),
                const SizedBox(height: 24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _saveItem(selectedFolderId),
                    child: const Text('Save Item'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  void _showFolderSelection(BuildContext context, List<FolderModel> folders) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext ctx) {
        return ListView.builder(
          itemCount: folders.length, // No "New Folder" option anymore
          itemBuilder: (context, index) {
            final folder = folders[index];
            return ListTile(
              title: Text(folder.name),
              onTap: () {
                setState(() {
                  selectedFolder = folder.name;  // Update selected folder name
                  selectedFolderId = folder.id;  // Update selected folder ID
                });
                Navigator.pop(ctx); // Close the modal after selecting folder
              },
            );
          },
        );
      },
    );
  }








  void _saveItem(String? folderId) {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter item name')),
      );
      return;
    }

    // Create the item model with the passed folderId
    final item = ItemModel(
      id: widget.existingItem?.id ?? uuid.v4(),
      name: nameController.text,
      quantity: quantity,
      folderId: folderId!,  // Use the passed folderId (either selected or newly created)
      expirationDate: selectedDate ?? DateTime.now(),
      isPinned: isPinned,
      isTemplate: isTemplate,
      createdAt: widget.existingItem?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Add or update the item using the ItemBloc
    context.read<ItemBloc>().add(
      widget.existingItem != null
          ? UpdateItemEvent(item)
          : AddItemEvent(item),
    );

    // Close the screen
    Navigator.pop(context);
  }

}
