import 'package:flutter/material.dart';

final lightThemeData = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    surface: Colors.white,
    primary: Colors.white,
    onPrimary: Colors.black,
    secondary: Color(0xccf4f4f4),
    secondaryContainer: Color(0xffdfe1e5),
    onSecondary: Colors.black,
  ),
  textTheme: const TextTheme(
      titleMedium: TextStyle(fontSize: 14, color: Colors.black)),
  useMaterial3: true,
);

final darkThemeData = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
      surface: Color(0xff282c34),
      primary: Color(0xff282c34),
      secondary: Color(0xff21252b),
      secondaryContainer: Color(0xff2c313a),
      onPrimary: Colors.white,
      onSecondary: Colors.white),
  textTheme: const TextTheme(
      titleMedium: TextStyle(fontSize: 14, color: Colors.white)),
);

bool isDarkMode(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;
