import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/item.dart';
import '../../bloc/item/item_bloc.dart';
import '../../bloc/item/item_event.dart';
import '../../bloc/item/item_state.dart';
import '../../bloc/language/language_bloc.dart';
import '../../bloc/language/language_event.dart';
import '../../bloc/theme/theme_bloc.dart';


class ItemPage extends StatelessWidget {
  const ItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              _showLanguageDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleTheme());
            },
          ),
        ],
      ),

      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.items.isEmpty) {
            return const Center(child: Text('No items found.'));
          }

          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return ListTile(
                leading: item.image != null
                    ? Image.network(item.image!, width: 40, height: 40, fit: BoxFit.cover)
                    : const Icon(Icons.folder),
                title: Text(item.name),
                subtitle: Text(item.isFolder
                    ? 'Folder'
                    : 'Quantity: ${item.quantity ?? 0}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _showItemDialog(context, isEdit: true, item: item);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<ItemBloc>().add(DeleteItem(item.id));
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showItemDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Choose Language'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.read<LanguageBloc>().add(const ToggleLanguageEvent(Locale('en')));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('English'),
            ),
            TextButton(
              onPressed: () {
                context.read<LanguageBloc>().add(const ToggleLanguageEvent(Locale('hi')));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Hindi'),
            ),
          ],
        );
      },
    );
  }
  void _showItemDialog(BuildContext context, {bool isEdit = false, ItemModel? item}) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final quantityController = TextEditingController(
      text: item?.quantity?.toString() ?? '',
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Edit Item' : 'Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity (optional)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final quantityText = quantityController.text.trim();
                final quantity = quantityText.isNotEmpty ? int.tryParse(quantityText) : null;

                if (name.isEmpty) return;

                final newItem = ItemModel(
                  id: isEdit ? item!.id : DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  image: null,
                  quantity: quantity,
                  parentId: null,
                  isFolder: false,
                  createdAt: DateTime.now(),
                );

                if (isEdit) {
                  context.read<ItemBloc>().add(EditItem(newItem));
                } else {
                  context.read<ItemBloc>().add(AddItem(newItem));
                }

                Navigator.pop(context);
              },
              child: Text(isEdit ? 'Save' : 'Add'),
            ),
          ],
        );
      },
    );
  }
}
