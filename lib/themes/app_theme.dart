import 'package:flutter/material.dart';

import '../models/mybooth_theme.dart';

class AppTheme {
  static ThemeData theme(MyBoothTheme myBoothTheme) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: myBoothTheme.primaryColor,
      primary: myBoothTheme.primaryColor,
      secondary: myBoothTheme.accentColor,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: myBoothTheme.backgroundColor,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: myBoothTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: myBoothTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: myBoothTheme.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: myBoothTheme.primaryColor,
            width: 2,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: myBoothTheme.primaryColor,
        contentTextStyle: const TextStyle(color: Colors.white),
      ),
    );
  }
}
