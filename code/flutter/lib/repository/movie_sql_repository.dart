import 'package:trackinator_flutter_v2/model/movie.dart';
import 'package:trackinator_flutter_v2/repository/abstract/repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MovieSqlRepository implements Repository<Movie> {
  static const String tableName = 'movies';
  static const String dbName = 'movie_database.db';

  MovieSqlRepository._privateConstructor();

  static final MovieSqlRepository instance =
      MovieSqlRepository._privateConstructor();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }

    return await _initDB();
  }

  _initDB() async {
    return openDatabase(join(await getDatabasesPath(), 'movie_database.db'),
        onCreate: (db, version) {
      return db.execute('CREATE TABLE $tableName ('
          'id INTEGER PRIMARY KEY, '
          'dateWatched TEXT, '
          'title TEXT, '
          'imageUrl TEXT, '
          'notes TEXT, '
          'rating INT)');
    }, version: 1);
  }

  @override
  Future<void> delete(int id) async {
    final db = await instance.database;

    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Movie>> getAll() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return Movie(
        maps[i]['id'],
        maps[i]['dateWatched'],
        maps[i]['title'],
        maps[i]['imageUrl'],
        maps[i]['notes'],
        maps[i]['rating'],
      );
    });
  }

  @override
  Future<Movie> getById(int id) async {
    final db = await instance.database;

    final List<Map<String, dynamic>> maps =
        await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    final map = maps[0];

    return Movie(
      map['id'],
      map['dateWatched'],
      map['title'],
      map['imageUrl'],
      map['notes'],
      map['rating'],
    );
  }

  @override
  Future<void> insert(Movie movie) async {
    final db = await instance.database;

    await db.insert(tableName, movie.movieMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> update(int id, Movie movie) async {
    final db = await instance.database;

    await db.update(
      tableName,
      movie.movieMap(),
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<void> deleteAll() async {
    final db = await instance.database;

    await db.delete(tableName);
  }
}
