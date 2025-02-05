import 'package:butce/DetailScreen/DetailS.dart';
import 'package:butce/Users/User.dart';
import 'package:butce/notifications/notifications.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../HomeScreen/HomeScreen.dart';
import 'package:intl/intl.dart';

// Tarihi formatlamak için fonksiyon
String formatTarih(String isoDate) {
  DateTime dateTime = DateTime.parse(isoDate);
  return DateFormat('dd/MM/yyyy HH:mm').format(dateTime); // Gün/Ay/Yıl Saat:Dakika
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class InputAndNavbarScreen extends StatefulWidget {
  final String userEmail;

  InputAndNavbarScreen({required this.userEmail});

  @override
  _InputAndNavbarScreenState createState() => _InputAndNavbarScreenState();
}

class _InputAndNavbarScreenState extends State<InputAndNavbarScreen> {
  int _currentIndex = 1;
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  final _controller3 = TextEditingController();

  String? _selectedType;

  String?_selectedIncomeExpense;

  List<String> _types = [];

  List<String> _gelirgider = ["GELIR","GIDER"];

  Database? _database;

  @override
  void initState() {
    super.initState();
    _initializeDB();
  }

  Future<void> _initializeDB() async {
    _database = await initializeDB();
    await _checkAndCreateTable();
    await _manuelKategoriGetir();
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'user_database.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE bilanco ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "ad TEXT, "
              "aciklama TEXT, "
              "fiyat REAL, "
              "tur TEXT, "
              "gelir_gider TEXT, "
              "userid INTEGER, "
              "eklenme_tarihi TEXT, "
              "FOREIGN KEY(userid) REFERENCES users(id) ON DELETE CASCADE"
              ");",
        );
      },
      version: 1,
    );
  }

  Future<void> _checkAndCreateTable() async {
    if (_database == null) return;

    await _database!.execute(
      "CREATE TABLE IF NOT EXISTS bilanco ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "ad TEXT, "
          "aciklama TEXT, "
          "fiyat REAL, "
          "tur TEXT, "
          "gelir_gider TEXT, "
          "userid INTEGER, "
          "eklenme_tarihi TEXT, "
          "FOREIGN KEY(userid) REFERENCES users(id) ON DELETE CASCADE"
          ");",
    );
  }

  Future<void> _manuelKategoriGetir() async {
    if (_database == null) return;

    // Kullanıcı ID'sini al
    int? userId = await _getUserIdByEmail(widget.userEmail);
    if (userId == null) return;

    // Kullanıcıya özel kategorileri getir
    final List<Map<String, dynamic>> kategoriler = await _database!.query(
      'kategoriler',
      where: 'userid = ?',
      whereArgs: [userId],
    );

    setState(() {
      _types = kategoriler.map((kategori) {
        return kategori['kategori_adi'].toString();
      }).toList();
    });
  }

  Future<int?> _getUserIdByEmail(String email) async {
    if (_database == null) await _initializeDB();
    final List<Map<String, dynamic>> result = await _database!.query(
      'users',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first['id'];
    }
    print('Kullanıcı bulunamadı: $email');
    return null;
  }

  Future<void> insertBilanco(String ad, String aciklama, double fiyat, String tur, String gelirgider, String userEmail) async {
    int? userId = await _getUserIdByEmail(userEmail);

    if (userId != null) {
      try {
        int result = await _database!.insert(
          'bilanco',
          {
            'ad': ad,
            'aciklama': aciklama,
            'fiyat': fiyat,
            'tur': tur,
            'gelir_gider': gelirgider,
            'userid': userId,
            'eklenme_tarihi' : formatTarih(DateTime.now().toIso8601String()), // Tarih ekleme
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        if (result != 0) {
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(content: Text('Bütçe kalemi başarıyla eklendi!')),
          );
        } else {
          print('Veri eklenemedi.');
        }
      } catch (e) {
        print('Veritabanına eklenirken hata oluştu: $e');
      }
    } else {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Kullanıcı bulunamadı!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Bütçe Kalemi Ekleme - ${widget.userEmail}'),
          backgroundColor: Colors.blue,
          leading: null,
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _controller1,
                decoration: InputDecoration(labelText: 'Ad'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _controller2,
                decoration: InputDecoration(labelText: 'Açıklama'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _controller3,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Fiyat'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: _types.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Tür',
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 30),
              DropdownButtonFormField<String>(
                value: _selectedIncomeExpense,
                items: _gelirgider.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedIncomeExpense = newValue;
                  });
                },
                decoration: InputDecoration(
                  labelText: "GELIR/GİDER",
                  border: OutlineInputBorder(),
                ),
              ),


              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _onAddPressed();

                },
                child: Text('Ekle'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            // Navigator ile sayfalar arası geçiş yapılabilir
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BudgetTrackerHome(userEmail: widget.userEmail)),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => InputAndNavbarScreen(userEmail: widget.userEmail)),
                );
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DetailScreen(userEmail: widget.userEmail)),
                );
                break;
              case 3:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AccountsScreen(userEmail: widget.userEmail)),
                );
                break;
              case 4:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen(userEmail: widget.userEmail)),
                );
                break;
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Ekle',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              label: 'Detaylar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Hesaplar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Bildirimler',
            ),
          ],
        ),
      ),
    );
  }

  void _onAddPressed() async {
    if (_controller1.text.isNotEmpty && _controller2.text.isNotEmpty && _controller3.text.isNotEmpty && _selectedType != null) {
      await insertBilanco(
        _controller1.text,
        _controller2.text,
        double.parse(_controller3.text),
        _selectedType!,
        _selectedIncomeExpense!,
        widget.userEmail,
      );
      _clearForm();
      // Ana Sayfa'ya yönlendir
    } else {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(content: Text('Tüm alanları doldurun!')),
      );
    }
  }

  void _clearForm() {
    _controller1.clear();
    _controller2.clear();
    _controller3.clear();
    setState(() {
      _selectedType = null;
    });
  }
}
