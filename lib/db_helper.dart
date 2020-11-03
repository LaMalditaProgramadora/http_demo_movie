import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'movie.dart';

class DBHelper {
  String databaseName = 'movies';
  final int version = 1;
  Database db;

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'movies.db'),
          onCreate: (db, version) {
        db.execute('CREATE TABLE movies(id INTEGER PRIMARY KEY, title TEXT)');
      }, version: version);
    }
    return db;
  }

  Future<int> insertMovie(Movie movie) async {
    int id = await db.insert(databaseName, movie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> deleteMovie(Movie movie) async {
    int result =
        await db.delete(databaseName, where: 'id = ?', whereArgs: [movie.id]);
    return result;
  }

  Future<bool> isFavorite(Movie movie) async {
    List<Map<String, dynamic>> maps =
        await db.query(databaseName, where: 'id = ?', whereArgs: [movie.id]);
    return maps.length > 0;
  }
}
