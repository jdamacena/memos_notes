import 'package:get_it/get_it.dart';
import 'package:notes/repository/dao.dart';
import 'package:notes/repository/dao_impl.dart';
import 'package:notes/repository/notes_repository.dart';
import 'package:notes/repository/notes_repository_impl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerFactoryAsync<Database>(() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      onUpgrade: (db, oldVersion, newVersion) {
        db.execute('ALTER TABLE notes ADD archived BOOLEAN;');
      },
      onCreate: (db, version) => db.execute(
        'CREATE TABLE notes('
        'id INTEGER PRIMARY KEY, '
        'title TEXT, '
        'description TEXT, '
        'timestamp TEXT, '
        'archived BOOLEAN '
        ')',
      ),
      version: 4,
    );
  });

  getIt.registerSingleton<DAO>(DAOImpl(getIt.getAsync<Database>()));

  getIt.registerSingleton<NotesRepository>(NotesRepositoryImpl(getIt.get<DAO>()));
}
