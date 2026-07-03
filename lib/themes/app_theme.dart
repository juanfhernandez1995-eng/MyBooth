import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF7C3AED);
  static const Color background = Color(0xFFF8F5FF);
  static const Color darkText = Color(0xFF1F1F29);

  static ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(seedColor: primary),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: background,
        elevation: 0,
      ),
    );
  }
}