import 'package:notes/models/note.dart';
import 'package:notes/repository/dao.dart';
import 'package:sqflite/sqflite.dart';

class DAOImpl extends DAO {
  final Future<Database> _database;

  DAOImpl(this._database);

  @override
  Future<int> saveNoteAsync(Note note, String timestamp) async {
    final db = await _database;

    note.timestamp = timestamp;

    int id = await db.insert(
      'notes',
      note.toMap(withId: note.id > 0),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  @override
  Future<bool> deleteNoteAsync(int id) async {
    bool didDelete = false;

    if (id <= 0) return didDelete;

    final Database db = await _database;

    var numRowsDeleted = await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    didDelete = numRowsDeleted > 0;

    return didDelete;
  }

  @override
  Future<List<Note>> getNotArchivedNotesFromDbAsync() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps;

    maps = await db.query(
      'notes',
      where: "archived != ? OR archived IS NULL",
      whereArgs: [1],
    );

    // Convert the List<Map<String, dynamic> into a List<Note>.
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  @override
  Future<List<Note>> getArchivedNotesFromDbAsync() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps;

    maps = await db.query(
      'notes',
      where: 'archived = ?',
      whereArgs: [1],
    );

    // Convert the List<Map<String, dynamic> into a List<Note>.
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  @override
  Future<List<Note>> getAllNotesFromDbAsync() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps;

    maps = await db.query('notes');

    // Convert the List<Map<String, dynamic> into a List<Note>.
    return List.generate(maps.length, (i) => Note.fromMap(maps[i]));
  }

  /// Updates the "archived" status of a note. <br/>
  /// returns _true_ if the operation was successful.
  @override
  Future<bool> updateNoteArchivedStatusAsync(int id, bool archived) async {
    final Database db = await _database;

    var numRowsUpdated = await db.update(
      'notes',
      {'archived': archived ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );

    return numRowsUpdated == 1;
  }
}
