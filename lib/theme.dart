import 'package:flutter/material.dart';

class AppTheme {
  // Light theme settings
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue,
    ),
    textTheme: const TextTheme(
      // bodyText1: TextStyle(color: Colors.black),
      // bodyText2: TextStyle(color: Colors.black87),
    ),
    cardColor: Colors.blue[50],
  );

  // Dark theme settings
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[850],
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.grey[800],
    ),
    textTheme: const TextTheme(
      // bodyText1: TextStyle(color: Colors.white),
      // bodyText2: TextStyle(color: Colors.white70),
    ),
    cardColor: Colors.grey[800],
  );
}
