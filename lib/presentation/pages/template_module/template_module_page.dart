import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/template_module_item.dart';
import '../../bloc/template_module/template_module_bloc.dart';
import '../../bloc/template_module/template_module_event.dart';
import '../../bloc/template_module/template_module_state.dart';

class TemplateModulePage extends StatelessWidget {
  const TemplateModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Template Module')),
      body: BlocBuilder<TemplateModuleBloc, TemplateModuleState>(
        builder: (context, state) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator());
          if (state.items.isEmpty) return const Center(child: Text('No Items Found'));

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
          final result = await showDialog<TemplateModuleItem>(
            context: context,
            builder: (context) => const AddTemplateModuleItemDialog(),
          );
          if (result != null) {
            context.read<TemplateModuleBloc>().add(AddTemplateModuleItem(result));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddTemplateModuleItemDialog extends StatefulWidget {
  const AddTemplateModuleItemDialog({super.key});

  @override
  State<AddTemplateModuleItemDialog> createState() => _AddTemplateModuleItemDialogState();
}

class _AddTemplateModuleItemDialogState extends State<AddTemplateModuleItemDialog> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
          TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final item = TemplateModuleItem(title: titleController.text, description: descriptionController.text);
            Navigator.pop(context, item);
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
