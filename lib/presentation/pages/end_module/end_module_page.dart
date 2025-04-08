import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/end_module_item.dart';
import '../../../core/constants/app_strings.dart';
import '../../bloc/end_module/end_module_bloc.dart';
import '../../bloc/end_module/end_module_event.dart';
import '../../bloc/end_module/end_module_state.dart';

class EndModulePage extends StatelessWidget {
  const EndModulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.endModuleTitle)),
      body: BlocBuilder<EndModuleBloc, EndModuleState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.items.isEmpty) {
            return const Center(child: Text(AppStrings.noEndModulesFound));
          }

          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.detail),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<EndModuleItem>(
            context: context,
            builder: (context) => const AddEndModuleItemDialog(),
          );
          if (result != null) {
            context.read<EndModuleBloc>().add(AddEndModuleItem(result));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddEndModuleItemDialog extends StatefulWidget {
  const AddEndModuleItemDialog({super.key});

  @override
  State<AddEndModuleItemDialog> createState() => _AddEndModuleItemDialogState();
}

class _AddEndModuleItemDialogState extends State<AddEndModuleItemDialog> {
  final nameController = TextEditingController();
  final detailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.addItem),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: AppStrings.name),
          ),
          TextField(
            controller: detailController,
            decoration: const InputDecoration(labelText: AppStrings.detail),
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
            final item = EndModuleItem(
              name: nameController.text,
              detail: detailController.text,
            );
            Navigator.pop(context, item);
          },
          child: const Text(AppStrings.add),
        ),
      ],
    );
  }
}
