import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Colors.blueAccent,
        secondary: Colors.orange,
        surface: Colors.white,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 25.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
        headlineMedium: TextStyle(
          fontSize: 20.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
        headlineSmall: TextStyle(
          fontSize: 17.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.blue,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Colors.blueAccent,
        secondary: Colors.orange,
        surface: Colors.black,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 25.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
        headlineMedium: TextStyle(
          fontSize: 20.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
        headlineSmall: TextStyle(
          fontSize: 17.0,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.blueGrey,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}
