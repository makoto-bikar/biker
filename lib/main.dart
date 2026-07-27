import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const BikarApp());
}

class BikarApp extends StatelessWidget {
  const BikarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bikar',
      home: const HomeScreen(),
    );
  }
}