import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'db_easy_id_photo_entity.dart';
import '../utils/logger.dart';

class DbHelper {
  static Database? _database;
  static const String _tableName = 'photo_history';
  
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'easy_id_photo.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        image_path TEXT NOT NULL,
        thumbnail_path TEXT NOT NULL,
        width REAL NOT NULL,
        height REAL NOT NULL,
        unit TEXT NOT NULL,
        format TEXT NOT NULL,
        resolution TEXT NOT NULL,
        brightness INTEGER NOT NULL,
        skin_smoothing INTEGER NOT NULL,
        skin_tone INTEGER NOT NULL,
        background_color TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');
    Logger.i('Database created successfully');
  }
  
  static Future<int> insertPhoto(PhotoHistoryEntity photo) async {
    final db = await database;
    try {
      final id = await db.insert(_tableName, photo.toMap());
      Logger.i('Photo inserted with id: $id');
      return id;
    } catch (e) {
      Logger.e('Error inserting photo', e);
      rethrow;
    }
  }
  
  static Future<List<PhotoHistoryEntity>> getAllPhotos() async {
    final db = await database;
    try {
      final maps = await db.query(
        _tableName,
        orderBy: 'created_at DESC',
      );
      return maps.map((map) => PhotoHistoryEntity.fromMap(map)).toList();
    } catch (e) {
      Logger.e('Error getting all photos', e);
      return [];
    }
  }
  
  static Future<PhotoHistoryEntity?> getPhotoById(int id) async {
    final db = await database;
    try {
      final maps = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isEmpty) return null;
      return PhotoHistoryEntity.fromMap(maps.first);
    } catch (e) {
      Logger.e('Error getting photo by id', e);
      return null;
    }
  }
  
  static Future<int> updatePhoto(PhotoHistoryEntity photo) async {
    final db = await database;
    try {
      final count = await db.update(
        _tableName,
        photo.toMap(),
        where: 'id = ?',
        whereArgs: [photo.id],
      );
      Logger.i('Photo updated: $count rows affected');
      return count;
    } catch (e) {
      Logger.e('Error updating photo', e);
      rethrow;
    }
  }
  
  static Future<int> deletePhoto(int id) async {
    final db = await database;
    try {
      final count = await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      Logger.i('Photo deleted: $count rows affected');
      return count;
    } catch (e) {
      Logger.e('Error deleting photo', e);
      rethrow;
    }
  }
}
