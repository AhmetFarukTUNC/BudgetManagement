import 'dart:core';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../AddAction/AddAction.dart';
import '../DetailScreen/DetailS.dart';
import '../UserActions/UserActions.dart';
import '../Users/User.dart';
import '../notifications/notifications.dart';
import '../AddCategory/AddCategory.dart';
import 'package:path/path.dart' as p;

class BudgetTrackerHome extends StatefulWidget {
  final String userEmail;

  BudgetTrackerHome({required this.userEmail});

  @override
  _BudgetTrackerHomeState createState() => _BudgetTrackerHomeState();
}

class _BudgetTrackerHomeState extends State<BudgetTrackerHome> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> actions = [];
  List<Map<String, dynamic>> categories = [];
  Database? _database;
  String selectedCategoryType = 'all'; // default tümünü göster
  List<String> _types = [];
  String? _selectedType; // Seçilen tür
  String totalIncome = "Yükleniyor..."; // Toplam gelir başlangıç değeri
  String totalGider = "Yükleniyor...";
  double netIncome = 0.0;






  @override
  void initState() {
    super.initState();
    _initializeDB();
    _loadUserBilanco();
    _manuelKategoriGetir();
    _calculateTotalIncome();
    _calculateTotalGider();
    _calculateNetIncome();
    _getDataByDate("04/01/2025 15:42");



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

  Future<List<Map<String, dynamic>>> _getDataByDate(String date) async {
    // SQLite veritabanı yolu
    String path = p.join(await getDatabasesPath(), 'user_database.db');

    // Veritabanına bağlan
    Database db = await openDatabase(path);

    // Tarih ve saat formatını kontrol etmek için
    List<Map<String, dynamic>> result = await db.query(
        'bilanco',
        where: 'strftime("%d/%m/%Y %H:%M", eklenme_tarihi) = ?',  // Belirli formatta sorgu
        whereArgs: [date]
    );

    // Verilerin işlenmesi
    await db.close();
    print(result);
    return result;
  }

  Future<String?> _calculateTotalIncome() async {
    try {
      if (_database == null) await _initializeDB();
      final int? userId = await _getUserIdByEmail(widget.userEmail);

      if (userId != null) {
        final List<Map<String, dynamic>> result = await _database!.rawQuery('''
          SELECT SUM(fiyat) AS toplamGelir
          FROM bilanco
          WHERE userid = ?
          AND gelir_gider = 'GELIR';
        ''', [userId]);


        setState(() {
          if (result.isNotEmpty && result.first["toplamGelir"] != null) {
            totalIncome = "${result.first["toplamGelir"]} ₺";
          } else {
            totalIncome = "0 ₺";
          }
        });

        return totalIncome;


      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  Future<String?> _calculateTotalGider() async {
    try {
      if (_database == null) await _initializeDB();
      final int? userId = await _getUserIdByEmail(widget.userEmail);

      if (userId != null) {
        final List<Map<String, dynamic>> result = await _database!.rawQuery('''
          SELECT SUM(fiyat) AS toplamGider
          FROM bilanco
          WHERE userid = ?
          AND gelir_gider = 'GIDER';
        ''', [userId]);


        setState(() {
          if (result.isNotEmpty && result.first["toplamGider"] != null) {
            totalGider = "${result.first["toplamGider"]} ₺";
          } else {
            totalGider = "0 ₺";
          }
        });

        return totalGider;


      }
    } catch (e) {
      print('Hata: $e');
    }
  }

  Future<String?> _calculateNetIncome() async {
    String? totalIncome = await _calculateTotalIncome();
    String? totalGider = await _calculateTotalGider();

    if (totalIncome != null && totalGider != null) {
      // Rakam olmayan karakterleri temizleme
      totalIncome = totalIncome.replaceAll(RegExp(r'[^0-9.]'), ''); // sadece tam sayı ve ondalıklı kısmı
      totalGider = totalGider.replaceAll(RegExp(r'[^0-9.]'), '');

      try {
        if (totalIncome.isNotEmpty) {
          double income = double.parse(totalIncome);

          double gider = double.parse(totalGider);
          netIncome = income - gider;

          return '${netIncome.toStringAsFixed(2)} ₺'; // İki basamaklı ondalıklı kısmı ile dönüştürme
        }
      } catch (e) {
        print('Çeviri hatası: $e');
      }
    }

    return "0 ₺";
  }










  final List<BottomNavigationBarItem> _navBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
    BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Ekle'),
    BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Detaylar'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hesaplar'),
    BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Bildirim'),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      // "Ekle" butonuna tıklandığında AddAction sayfasına yönlendir
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InputAndNavbarScreen(userEmail: widget.userEmail),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(userEmail: widget.userEmail),
        ),
      );
    }
    else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AccountsScreen(userEmail: widget.userEmail),
        ),
      );
    }
    else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationScreen(userEmail: widget.userEmail),
        ),
      );
    }

    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BudgetTrackerHome(userEmail: widget.userEmail),
        ),
      );
    }
  }

  List<Widget> _drawerItems(BuildContext context) {
    return [
      UserAccountsDrawerHeader(
        accountName: Text(widget.userEmail.split('@')[0]),
        accountEmail: Text(widget.userEmail),
        currentAccountPicture: CircleAvatar(
          backgroundImage: NetworkImage(
              "https://randomuser.me/api/portraits/men/1.jpg"),
        ),
        decoration: BoxDecoration(
          color: Colors.blue,
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
        ),
      ),
      _buildDrawerItem(Icons.notifications, 'Bildirimler', NotificationScreen(userEmail: widget.userEmail)),
      _buildDrawerItem(Icons.person, 'Hesaplar', AccountsScreen(userEmail: widget.userEmail)),
      _buildDrawerItem(
        Icons.info,
        'Detaylar',
        DetailScreen(userEmail: widget.userEmail),
      ),
      _buildDrawerItem(
        Icons.add,
        'Ekle',
        InputAndNavbarScreen(userEmail: widget.userEmail),
      ),
      _buildDrawerItem(
        Icons.home,
        'Ana Sayfa',
        BudgetTrackerHome(userEmail: widget.userEmail),
      ),
      _buildDrawerItem(
        Icons.category_outlined,
        'Kategori Ekle',
        CategoryAddScreen(userEmail: widget.userEmail),
      ),
    ];
  }

  ListTile _buildDrawerItem(IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text("İyi günler, ${widget.userEmail}"),
        leading: Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    "https://randomuser.me/api/portraits/men/1.jpg",
                  ),
                ),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen(userEmail: widget.userEmail)),
              );
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: _drawerItems(context),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildTransactionListTitle(),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),

          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        items: _navBarItems,
      ),
    );
  }


  Widget _buildHeader() {
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Toplam Bakiye", style: TextStyle(color: Colors.white, fontSize: 16)),
          SizedBox(height: 8),
          Text(netIncome.toString(),
              style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[500],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Toplam Gelir:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),  // Metinler arasında boşluk
                      Text(
                        '$totalIncome',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Toplam Gider:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '$totalGider',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),




        ],
      ),
    );
  }

  List<Map<String, dynamic>> _balanceData = [
    {"title": "Kazanç", "amount": "", "color": Colors.green},
    {"title": "Borç", "amount": "- 7000 TL", "color": Colors.red},
  ];



  List<Widget> _buildBalanceCards() {

    return _balanceData.map((item) {
      return _buildCreditDebitCard(item["title"], item["amount"], item["color"]);
    }).toList();
  }

  Widget _buildCreditDebitCard(String title, String amount, Color color) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: color)),
          Text(amount, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildTransactionListTitle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Gelir - Gider Listesi",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }



  Widget _buildTransactionItem(
      String title, String amount, String balance, IconData icon, Color color) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(balance),
        trailing: Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ),
    );
  }
}
