import 'package:notes/models/note.dart';
import 'package:notes/models/notes_filter_options.dart';

abstract class NotesRepository {
  Future<List<Note>> getNotesFromDbAsync(NotesFilterOptions filter);

  Future<int> saveNoteAsync(Note note, String timestamp);

  Future<bool> deleteNoteAsync(int id);

  Future<bool> updateNoteArchivedStatusAsync(int id, bool archived);
}
