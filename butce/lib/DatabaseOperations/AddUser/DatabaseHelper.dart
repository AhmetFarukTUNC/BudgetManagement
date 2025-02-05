import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // Veritabanı başlatma
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  // Veritabanı oluşturma
  Future<Database> _initDb() async {
    // Uygulamanın kalıcı veritabanı yolu
    String path = join(await getDatabasesPath(), 'user_database.db');

    print('Veritabanı Yolu: $path');

    // Veritabanı oluşturma veya açma
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            '''
          CREATE TABLE IF NOT EXISTS users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT UNIQUE,
            password TEXT
          )
          '''
        );
      },
    );
  }

  // Kullanıcı kaydı
  Future<int> registerUser(String email, String password) async {
    final db = await database;

    var existingUser = await getUserByEmail(email);
    if (existingUser != null) {
      return -1;  // Kullanıcı zaten kayıtlı
    }

    Map<String, dynamic> user = {
      'email': email.toLowerCase(),
      'password': password
    };

    return await db.insert('users', user);
  }

  // Oturum açma işlemi
  Future<bool> loginUser(String email, String password) async {
    final db = await database;
    var result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email.toLowerCase(), password],
    );

    if (result.isNotEmpty) {
      return true;
    }
    return false;
  }

  // Kullanıcı sorgulama (email ile)
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    var result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Tüm kullanıcıları listeleme (test için)
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }
}
