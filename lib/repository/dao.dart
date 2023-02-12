import 'package:notes/models/note.dart';

abstract class DAO {
  Future<int> saveNoteAsync(Note note, String timestamp);

  Future<bool> deleteNoteAsync(int id);

  Future<List<Note>> getNotArchivedNotesFromDbAsync();

  Future<List<Note>> getArchivedNotesFromDbAsync();

  Future<List<Note>> getAllNotesFromDbAsync();

  Future<bool> updateNoteArchivedStatusAsync(int id, bool archived);
}
