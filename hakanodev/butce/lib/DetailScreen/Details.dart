import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../AddAction/AddAction.dart';
import '../HomeScreen/HomeScreen.dart';
import '../Users/User.dart';
import '../notifications/notifications.dart';
import 'package:intl/intl.dart';




final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class DetailScreen extends StatefulWidget {
  final String userEmail;

  DetailScreen({required this.userEmail});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _currentIndex = 2;
  List<Map<String, dynamic>> actions = [];
  List<Map<String, dynamic>> categories = [];
  Database? _database;
  String selectedCategoryType = 'all'; // default tümünü göster
  List<String> _types = [];
  String? _selectedType; // Seçilen tür

  @override
  void initState() {
    super.initState();
    _initializeDB();
    _loadUserBilanco();
    _manuelKategoriGetir();
  }

  Future<void> _initializeDB() async {
    _database = await initializeDB();
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      p.join(path, 'user_database.db'),
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE users ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "email TEXT NOT NULL UNIQUE"
              ");",
        );
        await database.execute(
          "CREATE TABLE bilanco ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "ad TEXT, "
              "aciklama TEXT, "
              "fiyat REAL, "
              "tur TEXT, "
              "gelir_gider TEXT, "
              "userid INTEGER, "
              "FOREIGN KEY(userid) REFERENCES users(id) ON DELETE CASCADE"
              ");",
        );
        await database.execute(
            "CREATE INDEX idx_userid ON bilanco(userid);"
        );
        await database.execute(
          "CREATE TABLE kategoriler ("
              "id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "name TEXT, "
              "type TEXT, "
              "userid INTEGER, "
              "FOREIGN KEY(userid) REFERENCES users(id) ON DELETE CASCADE"
              ");",
        );
      },
      version: 1,
    );
  }

  Future<void> _loadUserBilanco() async {
    if (_database == null) {
      await _initializeDB();
    }

    final int? userId = await _getUserIdByEmail(widget.userEmail);
    if (userId != null) {
      final List<Map<String, dynamic>> bilancos = await _database!.query(
        'bilanco',
        where: 'userid = ?',
        whereArgs: [userId],
      );
      setState(() {
        actions = bilancos;
      });
    }
  }

  Future<int?> _getUserIdByEmail(String email) async {
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

  Future<void> _filterActions(String categoryType) async {
    if (_database == null) await _initializeDB();
    final int? userId = await _getUserIdByEmail(widget.userEmail);
    if (userId != null) {
      final List<Map<String, dynamic>> bilancos = await _database!.query(
        'bilanco',
        where: 'userid = ? AND tur = ?',
        whereArgs: [userId, categoryType],
      );
      setState(() {
        actions = bilancos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Borç Detayları - ${widget.userEmail}'),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [


              ],
            ),

            Expanded(
              child: actions.isEmpty
                  ? Center(
                child: Text(
                  'Henüz kayıt yok',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: actions.length,
                itemBuilder: (context, index) {
                  final action = actions[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10),
                      leading: Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 40,
                        color: Colors.blueAccent,
                      ),
                      title: Text(
                        action['ad'] ?? 'Bilinmiyor',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            action['aciklama'] ?? '',
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Kategori: ${action['tur'] ?? ''}',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${action['fiyat']} ₺',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${action['eklenme_tarihi']} ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            action['gelir_gider'] == 'GELIR' ? 'GELİR' : 'GİDER',
                            style: TextStyle(
                              color: action['gelir_gider'] == 'GELIR'
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            switch (index) {
              case 0:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BudgetTrackerHome(userEmail: widget.userEmail)),
                );
                break;
              case 1:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          InputAndNavbarScreen(userEmail: widget.userEmail)),
                );
                break;
              case 2:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailScreen(userEmail: widget.userEmail)),
                );
                break;
              case 3:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AccountsScreen(userEmail: widget.userEmail)),
                );
                break;
              case 4:
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NotificationScreen(userEmail: widget.userEmail)),
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
}
