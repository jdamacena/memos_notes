import 'package:notes/models/note.dart';
import 'package:notes/models/notes_filter_options.dart';
import 'package:notes/repository/dao.dart';
import 'package:notes/repository/notes_repository.dart';

class NotesRepositoryImpl extends NotesRepository {
  final DAO dao;

  NotesRepositoryImpl(this.dao);

  @override
  Future<bool> deleteNoteAsync(int id) {
    return dao.deleteNoteAsync(id);
  }

  @override
  Future<List<Note>> getNotesFromDbAsync(NotesFilterOptions filter) {
    switch (filter) {
      case NotesFilterOptions.archived:
        return dao.getArchivedNotesFromDbAsync();
      case NotesFilterOptions.notArchived:
        return dao.getNotArchivedNotesFromDbAsync();
      case NotesFilterOptions.all:
        return dao.getAllNotesFromDbAsync();
    }
  }

  @override
  Future<int> saveNoteAsync(Note note, String timestamp) {
    return dao.saveNoteAsync(note, timestamp);
  }

  @override
  Future<bool> updateNoteArchivedStatusAsync(int id, bool archived) {
    return dao.updateNoteArchivedStatusAsync(id, archived);
  }
}