import 'package:get_it/get_it.dart';
import 'package:notes/repository/DAO.dart';
import 'package:notes/pages/home_page.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerFactoryAsync<Database>(() async {
    return await openDatabase(
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
  });

  getIt.registerSingleton<DAO>(DAO(getIt.getAsync<Database>()));
  getIt.registerFactory<MyHomePage>(() => MyHomePage());
}
