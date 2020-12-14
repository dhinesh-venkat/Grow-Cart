import 'package:flutter/material.dart';

final theme = ThemeData(
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    headline3: TextStyle(
        fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),
    headline4: TextStyle(fontSize: 24, color: Colors.white),
    bodyText2:
        TextStyle(fontSize: 14.0, fontFamily: 'Fryo', color: Colors.white),
  ),
  primaryColorDark: const Color(0xFF0097A7),
  primaryColorLight: const Color(0xFFB2EBF2),
  primaryColor: Color.fromRGBO(66, 67, 69, 1),
  accentColor: Colors.orange,
//  scaffoldBackgroundColor: const Color(0xFFE0F2F1),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
