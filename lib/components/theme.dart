import 'package:flutter/material.dart';

class AppTheme {
  static const tootie = Color(0xFF6D2E3C);
  static const beige = Color(0xFFCEBEBE);
  static const fairouzi = Color(0xFF50A2A7);
  static const dustyRose = Color(0xFFA26769);
  

  static ThemeData light() {
    final cs = const ColorScheme(
      brightness: Brightness.light,
      primary: tootie, //button
      onPrimary: beige, //text on button
      secondary: fairouzi,
      onSecondary: Colors.white, //its required i just had to put it
      tertiary: dustyRose,
      surface: beige,
      onSurface: tootie,
      error: Color.fromARGB(255, 165, 15, 15), //same here
      onError: Colors.white, //same here
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      fontFamily: 'BellotaText',
      scaffoldBackgroundColor: cs.surface,
    );
  }

  static ThemeData dark() {
    final cs = const ColorScheme(
      brightness: Brightness.dark,
      primary: beige,     
      onPrimary: tootie,  
      secondary: fairouzi,
      onSecondary: Colors.black,
      tertiary: dustyRose,
      surface: tootie,    
      onSurface: beige,   
      error: Color.fromARGB(255, 165, 15, 15),
      onError: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,
      fontFamily: 'BellotaText',
      scaffoldBackgroundColor: cs.surface,
    );
  }
}
