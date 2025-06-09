import 'package:flutter/material.dart';

import 'screens/login_page.dart';
import 'screens/register_account_page.dart';
import 'screens/register_patient_page.dart';
import 'screens/dashboard_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;

  void login() {
    setState(() {
      isLoggedIn = true;
    });
  }

  void logout() {
    setState(() {
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daftar Pasien Klinik',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) =>
            isLoggedIn ? DashboardPage(logoutCallback: logout) : LoginPage(loginCallback: login),
        '/login': (context) => LoginPage(loginCallback: login),
        '/register': (context) => RegisterAccountPage(),
        '/register_patient': (context) => RegisterPatientPage(),
        '/dashboard': (context) => DashboardPage(logoutCallback: logout),
      },
    );
  }
}
