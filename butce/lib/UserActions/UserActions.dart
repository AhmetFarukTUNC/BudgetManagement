import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../DatabaseOperations/AddUser/DatabaseHelper.dart';
import '../HomeScreen/HomeScreen.dart';
import '../Users/User.dart';
import '../notifications/notifications.dart';

class UserActionsScreen extends StatefulWidget {
  @override
  _UserActionsScreenState createState() => _UserActionsScreenState();
}

class _UserActionsScreenState extends State<UserActionsScreen> {
  bool isLoginScreen = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = isLoginScreen ? Colors.blue.shade700 : Colors.green.shade600;
    final buttonColor = isLoginScreen ? Colors.blue : Colors.green;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 6,
        title: Text(
          isLoginScreen ? 'Oturum Aç' : 'Kayıt Ol',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Icon(
                      isLoginScreen ? Icons.lock_open : Icons.person_add,
                      size: 100,
                      color: primaryColor,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Kullanıcı Adı',
                        prefixIcon: Icon(Icons.person, color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'E-posta boş olamaz!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Şifre',
                        prefixIcon: Icon(Icons.lock, color: primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Şifre boş olamaz!';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _handleAuth();
                        }
                      },
                      child: Text(
                        isLoginScreen ? 'Oturum Aç' : 'Kayıt Ol',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLoginScreen = !isLoginScreen;
                        });
                      },
                      child: Text(
                        isLoginScreen
                            ? 'Hesabınız yok mu? Kayıt olun'
                            : 'Zaten hesabınız var mı? Oturum açın',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Şifreyi SHA-256 ile hashleme
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Kullanıcı oturum açma ve kayıt işlemleri
  void _handleAuth() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (isLoginScreen) {
      // Şifreyi hashleyip veritabanındaki hashlenmiş şifreyle karşılaştır
      String hashedPassword = _hashPassword(password);
      bool isLoggedIn = await dbHelper.loginUser(email, hashedPassword);
      if (isLoggedIn) {
        var userData = await dbHelper.getUserByEmail(email);
        if (userData != null) {
          String userEmail = userData['email'];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BudgetTrackerHome(userEmail: userEmail),
            ),
          );
        }
      } else {
        _showSnackbar('E-posta veya şifre hatalı.');
      }
    } else {
      // Şifreyi kaydetmeden önce hashle
      String hashedPassword = _hashPassword(password);
      int result = await dbHelper.registerUser(email, hashedPassword);
      if (result == -1) {
        _showSnackbar('Bu e-posta zaten kayıtlı!');
      } else {
        _showSnackbar('Kayıt başarılı!');
        setState(() {
          isLoginScreen = true;
        });
      }
    }
  }

  // Snackbar ile kullanıcıya bildirim göster
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
