import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'themes/app_theme.dart';

void main() {
  runApp(const MyBoothApp());
}

class MyBoothApp extends StatelessWidget {
  const MyBoothApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyBooth',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme(),
      home: const HomeScreen(),
    );
  }
}