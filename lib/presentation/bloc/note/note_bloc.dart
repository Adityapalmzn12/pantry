import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_event.dart';
import 'note_state.dart';
import '../../../data/repository/notes_repository.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository repository;

  NotesBloc(this.repository) : super(NotesState.initial()) {
    on<LoadNotes>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final notes = await repository.getNotes();
      emit(state.copyWith(notes: notes, isLoading: false));
    });

    on<AddNote>((event, emit) async {
      final updated = List.of(state.notes)..add(event.note);
      await repository.saveNotes(updated);
      emit(state.copyWith(notes: updated));
    });
  }
}
