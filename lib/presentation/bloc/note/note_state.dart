import '../../../data/model/note.dart';

class NotesState {
  final List<Note> notes;
  final bool isLoading;

  NotesState({required this.notes, required this.isLoading});

  factory NotesState.initial() => NotesState(notes: [], isLoading: true);

  NotesState copyWith({List<Note>? notes, bool? isLoading}) {
    return NotesState(
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
