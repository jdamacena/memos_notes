import 'package:notes/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DAO {
  static Future<Database> openDb() async {
    var database = await openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      onUpgrade: (db, oldVersion, newVersion) {
        db.execute('ALTER TABLE notes ADD timestamp TEXT;');
      },
      onCreate: (db, version) => db.execute(
        'CREATE TABLE notes('
        'id INTEGER PRIMARY KEY, '
        'title TEXT, '
        'description TEXT, '
        'timestamp TEXT'
        ')',
      ),
      version: 3,
    );

    return database;
  }

  Future<int> saveNote(Note note) async {
    final db = await openDb();

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

  Future<bool> deleteNote(int id) async {
    bool didDelete = false;

    if (id <= 0) return didDelete;

    final Database db = await openDb();

    var numRowsDeleted = await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );

    didDelete = numRowsDeleted > 0;

    return didDelete;
  }

  /// A method that retrieves all the notes from the notes table.
  Future<List<Note>> getFutureNotesFromDb() async {
    // Get a reference to the database.
    final db = await openDb();

    // Query the table for all The notes.
    final List<Map<String, dynamic>> maps = await db.query('notes');

    // Convert the List<Map<String, dynamic> into a List<Note>.
    var list = List.generate(maps.length, (i) {
      Map<String, dynamic> mapElement = maps[i];

      var timestamp = mapElement['timestamp'];

      return Note(
        id: mapElement['id'],
        title: mapElement['title'],
        description: mapElement['description'],
        timestamp: timestamp ?? '',
      );
    });

    return list;
  }
}
