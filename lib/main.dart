import 'package:flutter/material.dart';
import 'package:lib_club/presentation/pages/home_page.dart';
import 'package:lib_club/presentation/pages/login_page.dart';
import 'package:lib_club/presentation/pages/registration_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/register': (context) => RegistrationPage(),
      },
    );
  }
}
