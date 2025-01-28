import 'dart:ui';

import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = Color(0xFF627254);
  static Color background = Color(0xFFEEEEEE);
  static Color secondaryColor = Color(0xFF809D3C);
  static Color thirdColor = Color(0xFFA9C46C);

  static ThemeData mainTheme = ThemeData(
    useMaterial3: true,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.amber,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(primaryColor)
      )),
    textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 30
          )
        ),
    fontFamily: 'Merriweather'
    );
}
