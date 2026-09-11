import 'package:flutter/material.dart';
import 'Beranda.dart';


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
      home: Beranda(), // Mengarahkan ke Widget/Class Beranda
    );
  }
}