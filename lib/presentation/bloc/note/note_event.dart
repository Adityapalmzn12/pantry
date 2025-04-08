import '../../../data/model/note.dart';

abstract class NotesEvent {}

class LoadNotes extends NotesEvent {}

class AddNote extends NotesEvent {
  final Note note;
  AddNote(this.note);
}
