import 'package:butce/UserActions/UserActions.dart';
import 'package:flutter/material.dart';
import '../AddAction/AddAction.dart';
import '../DetailScreen/DetailS.dart';
import '../HomeScreen/HomeScreen.dart';
import '../notifications/notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AccountsScreen(userEmail: 'test@example.com'),  // Test için sabit email
    );
  }
}

class AccountsScreen extends StatelessWidget {
  final String userEmail;

  AccountsScreen({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hesaplar'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(  // Kartı dikeyde ve yatayda ortala
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 320,  // Kartın genişliği küçültüldü
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),  // İç boşluk artırıldı
                child: Column(
                  mainAxisSize: MainAxisSize.min,  // Kartı içeriğe göre küçült
                  crossAxisAlignment: CrossAxisAlignment.center,  // Ortala
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orangeAccent,
                      radius: 36,  // Avatar büyütüldü
                      child: Icon(Icons.account_circle, size: 40, color: Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Kullanıcı Adı: ${userEmail}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => UserActionsScreen()),  // Login ekranı yerine LoginScreen kullanılacak
                              (route) => false,  // Kendi sayfamız dışındaki tüm ekranları kaldır
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Çıkış Yap",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BudgetTrackerHome(userEmail: userEmail)),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InputAndNavbarScreen(userEmail: userEmail)),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DetailScreen(userEmail: userEmail)),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountsScreen(userEmail: userEmail)),
              );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen(userEmail: userEmail)),
              );
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Ekle'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Detaylar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hesaplar'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Bildirim'),
        ],
      ),
    );
  }
}
