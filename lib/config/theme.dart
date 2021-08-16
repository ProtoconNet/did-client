import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  brightness: Brightness.light,
  fontFamily: GoogleFonts.notoSans().fontFamily,
  primarySwatch: Colors.deepPurple,
  primaryColor: Colors.purple,
  primaryColorLight: Colors.purple,
  primaryColorDark: Colors.purple,
  accentColor: Colors.deepPurple,
);
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.notoSans().fontFamily,
  primarySwatch: Colors.purple,
  primaryColor: Colors.deepPurple,
  primaryColorLight: Colors.purple,
  primaryColorDark: Colors.purple,
  accentColor: Colors.deepPurple,
);
