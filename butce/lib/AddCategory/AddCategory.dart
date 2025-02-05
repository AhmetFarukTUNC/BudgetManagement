import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../HomeScreen/HomeScreen.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class CategoryAddScreen extends StatefulWidget {
  final String userEmail;

  CategoryAddScreen({required this.userEmail});

  @override
  _CategoryAddScreenState createState() => _CategoryAddScreenState();
}

class _CategoryAddScreenState extends State<CategoryAddScreen> {
  int _currentIndex = 1;
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initializeDB();
  }

  Future<void> _initializeDB() async {
    try {
      _database = await initializeDB();
      await _createTableIfNotExists();
    } catch (e) {
      print("Veritabanı başlatılırken hata oluştu: $e");
    }
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'user_database.db'),
      version: 3,
    );
  }

  Future<void> _createTableIfNotExists() async {
    if (_database == null) return;
    try {
      await _database!.execute(
        "CREATE TABLE IF NOT EXISTS kategoriler ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "kategori_adi TEXT, "
            "aciklama TEXT, "
            "userid INTEGER, "
            "FOREIGN KEY(userid) REFERENCES users(id) ON DELETE CASCADE"
            ");",
      );
    } catch (e) {
      print("Tablo oluşturulurken hata oluştu: $e");
    }
  }

  Future<int?> _getUserIdByEmail(String email) async {
    if (_database == null) return null;
    final List<Map<String, dynamic>> result = await _database!.query(
      'users',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first['id'];
    }
    return null;
  }

  Future<void> _insertCategory(String kategoriAdi, String aciklama) async {
    try {
      final int? userId = await _getUserIdByEmail(widget.userEmail);
      if (userId != null) {
        await _database!.insert(
          'kategoriler',
          {
            'kategori_adi': kategoriAdi,
            'aciklama': aciklama,
            'userid': userId,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        print("Kullanıcı bulunamadı.");
      }
    } catch (e) {
      print("Veri eklenirken hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kategori Ekle"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 16),
                child: Text(
                  "Kategori Ekle Formu",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    shadows: [
                      Shadow(
                        blurRadius: 5,
                        color: Colors.grey,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _categoryNameController,
                decoration: InputDecoration(
                  labelText: "Kategori Adı",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Açıklama",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                maxLines: 2,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final categoryName = _categoryNameController.text;
                  final description = _descriptionController.text;

                  if (categoryName.isNotEmpty && description.isNotEmpty) {
                    await _insertCategory(categoryName, description);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Kategori '$categoryName' eklendi!"),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BudgetTrackerHome(userEmail: widget.userEmail),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Lütfen tüm alanları doldurun!"),
                      ),
                    );
                  }
                },
                child: Text("Ekle"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
