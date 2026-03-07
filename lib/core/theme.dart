import 'package:flutter/material.dart';

final appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF7C4DFF),
    brightness: Brightness.dark,
    primary: const Color(0xFF7C4DFF),
    secondary: const Color(0xFFFF6D00),
    tertiary: const Color(0xFF00E5FF),
    surface: const Color(0xFF1A1A2E),
    onSurface: Colors.white,
  ),
  scaffoldBackgroundColor: const Color(0xFF0F0F23),
  useMaterial3: true,
  fontFamily: 'Roboto',
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF16213E),
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 22,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF7C4DFF),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      shadowColor: const Color(0xFF7C4DFF),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: const Color(0xFF7C4DFF),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  ),
  cardTheme: CardThemeData(
    elevation: 8,
    shadowColor: const Color(0xFF7C4DFF).withValues(alpha: 0.3),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: const Color(0xFF1A1A2E),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFF7C4DFF).withValues(alpha: 0.2),
    labelStyle: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    side: const BorderSide(color: Color(0xFF7C4DFF), width: 1.5),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF16213E),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFF7C4DFF)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: const Color(0xFF7C4DFF).withValues(alpha: 0.5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFF7C4DFF), width: 2),
    ),
    labelStyle: const TextStyle(color: Colors.white70),
    hintStyle: const TextStyle(color: Colors.white38),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color(0xFF16213E),
    contentTextStyle: const TextStyle(color: Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    behavior: SnackBarBehavior.floating,
  ),
);
