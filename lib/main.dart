import 'package:flutter/material.dart';
import 'user/beranda.dart';
import 'admin/admin_login.dart';
import 'admin/admin_main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eventify',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF615983), // Warna tema Eventify
      ),
      routes: {
        '/admin': (context) => const AdminLoginPage(),
        '/admin/dashboard': (context) => const AdminMainNavigation(),
      },
      home: const Beranda(), // Mengarahkan ke Beranda
    );
  }
}