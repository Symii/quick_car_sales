import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/car_ad.dart';
import '../models/user_profile.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('car_ads.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE car_ads (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        brand TEXT,
        model TEXT,
        year TEXT,
        engineCapacity TEXT,
        mileage TEXT,
        price TEXT,
        description TEXT,
        imagePath TEXT,
        isFavorite INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        surname TEXT,
        address TEXT,
        email TEXT
      )
    ''');
  }

  Future<int> insertCarAd(CarAd ad) async {
    final db = await instance.database;
    return await db.insert('car_ads', ad.toMap());
  }

  Future<List<CarAd>> getCarAds() async {
    final db = await instance.database;
    final result = await db.query('car_ads');
    return result.map((e) => CarAd.fromMap(e)).toList();
  }

  Future<void> updateCarAd(CarAd ad) async {
    final db = await instance.database;
    await db.update('car_ads', ad.toMap(), where: 'id = ?', whereArgs: [ad.id]);
  }

  Future<void> deleteCarAd(int id) async {
    final db = await instance.database;
    await db.delete('car_ads', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    final db = await instance.database;
    final result = await db.query('user_profile');
    if (result.isEmpty) {
      await db.insert('user_profile', profile.toMap());
    } else {
      await db.update(
        'user_profile',
        profile.toMap(),
        where: 'id = ?',
        whereArgs: [result.first['id']],
      );
    }
  }

  Future<UserProfile?> getUserProfile() async {
    final db = await instance.database;
    final result = await db.query('user_profile');
    if (result.isNotEmpty) {
      return UserProfile.fromMap(result.first);
    }
    return null;
  }
}
