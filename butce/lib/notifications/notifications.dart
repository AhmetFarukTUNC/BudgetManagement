import 'package:butce/AddAction/AddAction.dart';
import 'package:butce/DetailScreen/DetailS.dart';
import 'package:butce/HomeScreen/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

import '../Users/User.dart';

class NotificationScreen extends StatefulWidget {
  final String userEmail;

  NotificationScreen({required this.userEmail});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Database? _database;
  List<Map<String, dynamic>> notifications = [];
  int _selectedIndex = 4;  // Bildirimler ekranı için varsayılan index 4.

  @override
  void initState() {
    super.initState();
    _initializeDB().then((_) {
      _fetchNotifications();
    });
  }

  Future<void> _initializeDB() async {
    _database = await initializeDB();
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      p.join(path, 'user_database.db'),
      version: 1,
    );
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
    return null;
  }

  Future<void> _fetchNotifications() async {
    int? userId = await _getUserIdByEmail(widget.userEmail);

    if (userId != null) {
      List<Map<String, String>> formattedNotifications = [];

      // Bilanço verilerini al (Kullanıcıya özel)
      final List<Map<String, dynamic>> bilanco = await _database!.query(
        'bilanco',
        where: 'userid = ?',
        whereArgs: [userId],
      );

      bilanco.forEach((item) {
        formattedNotifications.add({
          "title": "Bilanço Güncellemesi",
          "description": "${item['ad']} işlemi eklendi.",
          "date": DateTime.now().toLocal().toString().split(' ')[0],
        });
      });

      // Kategoriler verilerini al (Kullanıcıya özel)
      final List<Map<String, dynamic>> kategoriler = await _database!.query(
        'kategoriler',
        where: 'userid = ?',
        whereArgs: [userId],
      );

      kategoriler.forEach((kategori) {
        formattedNotifications.add({
          "title": "Kategori Güncellemesi",
          "description": "${kategori['kategori_adi']} kategorisi eklendi.",
          "date": DateTime.now().toLocal().toString().split(' ')[0],
        });
      });

      setState(() {
        notifications = formattedNotifications;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kullanıcı bulunamadı!'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  // Sayfa değişimlerini yöneten fonksiyon
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (_selectedIndex == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BudgetTrackerHome(userEmail: widget.userEmail),
        ),
      );
    } else if (_selectedIndex == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => InputAndNavbarScreen(userEmail: widget.userEmail),
        ),
      );
    } else if (_selectedIndex == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(userEmail: widget.userEmail),
        ),
      );
    } else if (_selectedIndex == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AccountsScreen(userEmail: widget.userEmail),
        ),
      );
    }
    else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationScreen(userEmail: widget.userEmail),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bildirimler"),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);  // Önceki sayfaya dönme işlemi
            } else {
              // Eğer geri gidecek sayfa yoksa ana sayfaya yönlendir
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BudgetTrackerHome(userEmail: widget.userEmail),
                ),
              );
            }
          },
        ),



      ),
      body: Column(
        children: [

          Expanded(
            child: notifications.isEmpty
                ? Center(child: Text("Henüz kayıt yok"))
                : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return _buildNotificationItem(
                  title: notifications[index]["title"]!,
                  description: notifications[index]["description"]!,
                  date: notifications[index]["date"]!,
                  isLoginNotification: index == 0,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
            label: 'Bildirim',
          ),
        ],
      ),
    );
  }



  Widget _buildNotificationItem({
    required String title,
    required String description,
    required String date,
    bool isLoginNotification = false,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      color: isLoginNotification ? Colors.blue[100] : Colors.white,
      child: ListTile(
        leading: Icon(
          isLoginNotification
              ? Icons.check_circle
              : Icons.notifications_active,
          color: isLoginNotification ? Colors.green : Colors.blue,
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: Text(
          date,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ),
    );
  }
}