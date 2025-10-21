import 'package:flutter/material.dart';


class AppTheme {
  static const Color primary = Color(0xff155DFC);
  static const Color black = Color(0xff101828);
  static const Color white = Color(0xffFFFFFF);
  static const Color gray = Color(0xff4A5565);
  static  ThemeData  lightTheme = ThemeData(
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w400,
        color: black
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: gray
      ),
      titleSmall: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: black
      ),

    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
      )
    )
  );
  static  ThemeData  darkTheme = ThemeData();
}
