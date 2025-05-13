import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFFFF0000),
      onPrimary: Colors.white,
      secondary: Color(0xFFFF5252),
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      background: Colors.white,
      onBackground: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
    useMaterial3: true,
  );
}
