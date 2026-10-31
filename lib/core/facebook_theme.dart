import 'package:flutter/material.dart';

class FbPalette {
  static const blue = Color(0xFF0866FF);
  static const ink = Color(0xFF1C1E21);
  static const secondary = Color(0xFF65676B);
  static const background = Color(0xFFF0F2F5);
  static const border = Color(0xFFE5E7EB);
  static const green = Color(0xFF2DB26A);
}

ThemeData facebookTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: FbPalette.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: FbPalette.blue,
      primary: FbPalette.blue,
      surface: Colors.white,
    ),
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      foregroundColor: FbPalette.ink,
      titleTextStyle: TextStyle(
        fontSize: 21,
        color: FbPalette.ink,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: FbPalette.background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
    ),
  );
}
