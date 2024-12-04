import 'package:infinite_album/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'albums.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE albums (id INTEGER PRIMARY KEY, title TEXT)
        ''');
        await db.execute('''
          CREATE TABLE photos (id INTEGER PRIMARY KEY, url TEXT, albumId INTEGER)
        ''');
      },
    );
  }

  Future<void> insertAlbums(List<Album> albums) async {
    final db = await database;
    for (var album in albums) {
      await db.insert('albums', album.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> insertPhotos(List<Photo> photos) async {
    final db = await database;
    for (var photo in photos) {
      await db.insert('photos', photo.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Album>> fetchAlbums() async {
    final db = await database;
    final result = await db.query('albums');
    return result.map((json) => Album.fromJson(json)).toList();
  }

  Future<List<Photo>> fetchPhotos(int albumId) async {
    final db = await database;
    final result =
    await db.query('photos', where: 'albumId = ?', whereArgs: [albumId]);
    return result.map((json) => Photo.fromJson(json)).toList();
  }
}
