import 'package:notes/models/note.dart';
import 'package:notes/models/notes_filter_options.dart';
import 'package:sqflite/sqflite.dart';

class DAO {
  Future<Database> _database;

  DAO(this._database);

  Future<int> saveNoteAsync(Note note) async {
    final db = await this._database;

    if (note.timestamp.isEmpty) {
      // TODO extract timestamp (to be received as param)
      note.timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    }

    int id = await db.insert(
      'notes',
      note.toMap(withId: note.id > 0),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<bool> deleteNoteAsync(int id) async {
    bool didDelete = false;

    if (id <= 0) return didDelete;

    final Database db = await this._database;

    var numRowsDeleted = await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    didDelete = numRowsDeleted > 0;

    return didDelete;
  }

  Future<List<Note>> getNotesFromDbAsync(NotesFilterOptions filter) async {
    final db = await this._database;
    final List<Map<String, dynamic>> maps;

    switch (filter) {
      case NotesFilterOptions.archived:
      case NotesFilterOptions.notArchived:
        var whereExpression = 'archived = ?';

        if (filter == NotesFilterOptions.notArchived) {
          whereExpression = "archived != ? OR archived IS NULL";
        }

        maps = await db.query(
          'notes',
          where: whereExpression,
          whereArgs: [1],
        );
        break;
      case NotesFilterOptions.all:
        maps = await db.query('notes');
        break;
    }

    // Convert the List<Map<String, dynamic> into a List<Note>.
    var list = List.generate(maps.length, (i) {
      Map<String, dynamic> mapElement = maps[i];

      var timestamp = mapElement['timestamp'];
      var archived = mapElement['archived'] == 1;

      return Note(
        id: mapElement['id'],
        title: mapElement['title'],
        description: mapElement['description'],
        archived: archived,
        timestamp: timestamp ?? '',
      );
    });

    return list;
  }

  /// Updates the "archived" status of a note. <br/>
  /// returns _true_ if the operation was successful.
  Future<bool> updateNoteArchivedStatusAsync(int id, bool archived) async {
    final Database db = await this._database;

    var numRowsUpdated = await db.update(
      'notes',
      {'archived': archived ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );

    return numRowsUpdated == 1;
  }
}
