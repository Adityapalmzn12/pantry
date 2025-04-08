import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_strings.dart';
import '../../../data/model/anchored_item.dart';
import '../../bloc/anchored/anchored_bloc.dart';
import '../../bloc/anchored/anchored_event.dart';
import '../../bloc/anchored/anchored_state.dart';

class AnchoredPage extends StatelessWidget {
  const AnchoredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnchoredView();
  }
}

class AnchoredView extends StatelessWidget {
  const AnchoredView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.anchoredTitle),
      ),
      body: BlocBuilder<AnchoredBloc, AnchoredState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.items.isEmpty) {
            return const Center(child: Text(AppStrings.noAnchoredItems));
          }
          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.description),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<AnchoredItem>(
            context: context,
            builder: (context) => const AddAnchoredItemDialog(),
          );
          if (result != null) {
            context.read<AnchoredBloc>().add(AddAnchoredItem(result));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddAnchoredItemDialog extends StatefulWidget {
  const AddAnchoredItemDialog({super.key});

  @override
  State<AddAnchoredItemDialog> createState() => _AddAnchoredItemDialogState();
}

class _AddAnchoredItemDialogState extends State<AddAnchoredItemDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.anchoredTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: AppStrings.anchoredTitle),
          ),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: AppStrings.noAnchoredItems),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            final item = AnchoredItem(
              id: DateTime.now().toString(),
              title: titleController.text,
              description: descriptionController.text,
            );
            Navigator.pop(context, item);
          },
          child: const Text(AppStrings.ok),
        ),
      ],
    );
  }
}
