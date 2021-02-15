import 'package:flutter/material.dart';

final theme = ThemeData(
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
    headline3: TextStyle(
        fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),
    headline4: TextStyle(fontSize: 24, color: Colors.white),
    bodyText2:
        TextStyle(fontSize: 14.0, fontFamily: 'Fryo', color: Colors.white),
    bodyText1:
        TextStyle(fontSize: 14.0, fontFamily: 'Fryo', color: Colors.black),
  ),
  primaryColorDark: const Color.fromRGBO(36, 36, 32, 1),
  primaryColorLight: const Color.fromRGBO(241, 241, 241, 1),
  //primaryColor: Color.fromRGBO(66, 67, 69, 1),
  primaryColor: Color.fromRGBO(241, 241, 241, 1),
  accentColor: Colors.orange,
//  scaffoldBackgroundColor: const Color(0xFFE0F2F1),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
