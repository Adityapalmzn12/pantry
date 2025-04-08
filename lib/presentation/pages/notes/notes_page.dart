import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/note.dart';
import '../../../core/constants/app_strings.dart'; // Import AppStrings
import '../../bloc/note/note_bloc.dart';
import '../../bloc/note/note_event.dart';
import '../../bloc/note/note_state.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotesView();
  }
}

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.notesTitle)),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.notes.isEmpty) {
            return const Center(child: Text(AppStrings.noNotesFound));
          }
          return ListView.builder(
            itemCount: state.notes.length,
            itemBuilder: (context, index) {
              final note = state.notes[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<Note>(
            context: context,
            builder: (context) => const AddNoteDialog(),
          );
          if (result != null) {
            context.read<NotesBloc>().add(AddNote(result));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog({super.key});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.add),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: AppStrings.name),
          ),
          TextField(
            controller: contentController,
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
            final note = Note(
              id: DateTime.now().toString(),
              title: titleController.text,
              content: contentController.text,
            );
            Navigator.pop(context, note);
          },
          child: const Text(AppStrings.add),
        ),
      ],
    );
  }
}
