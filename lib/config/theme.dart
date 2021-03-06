import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final primary = createMaterialColor(const Color(0xFF5A24BE));
final secondary = createMaterialColor(const Color(0xFFED742F));

final theme = ThemeData(
  brightness: Brightness.light,
  fontFamily: GoogleFonts.notoSans().fontFamily,
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 93, letterSpacing: -1.5, color: Colors.black),
    headline2: TextStyle(fontSize: 60, letterSpacing: -0.52, color: Colors.black),
    headline3: TextStyle(fontSize: 48, letterSpacing: 0.0, color: Colors.black),
    headline4: TextStyle(fontSize: 34, letterSpacing: 0.25, color: Colors.black),
    headline5: TextStyle(fontSize: 24, letterSpacing: 0.0, color: Colors.black),
    headline6: TextStyle(fontSize: 20, letterSpacing: 0.0, color: Colors.black, fontWeight: FontWeight.w900),
    subtitle1: TextStyle(fontSize: 16, letterSpacing: 0.0, color: Colors.black),
    subtitle2: TextStyle(fontSize: 14, letterSpacing: 0.1, color: Colors.black),
    bodyText1: TextStyle(fontSize: 16, letterSpacing: 0.1, color: Colors.black),
    bodyText2: TextStyle(fontSize: 14, letterSpacing: 0.1, color: Colors.black),
    caption: TextStyle(fontSize: 13, letterSpacing: 0.0, color: Colors.black),
    overline: TextStyle(fontSize: 10, letterSpacing: 1.5, color: Colors.black),
    button: TextStyle(fontSize: 18, letterSpacing: -0.4, color: Colors.black, fontWeight: FontWeight.w700),
  ),
  primarySwatch: primary,
  colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xFF5A24BE),
      primaryVariant: primary.shade500,
      secondary: const Color(0xFFED742F),
      secondaryVariant: secondary.shade500,
      error: const Color(0xffba3183),
      background: const Color(0xfffafafa),
      surface: const Color(0xfffafafa),
      onPrimary: const Color(0xff222222),
      onError: const Color(0xff222222),
      onSecondary: const Color(0xff222222),
      onBackground: const Color(0xff222222),
      onSurface: const Color(0xff222222)),
);
final darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: GoogleFonts.notoSans().fontFamily,
  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 93, letterSpacing: -1.5, color: Colors.white),
    headline2: TextStyle(fontSize: 60, letterSpacing: -0.52, color: Colors.white),
    headline3: TextStyle(fontSize: 48, letterSpacing: 0.0, color: Colors.white),
    headline4: TextStyle(fontSize: 34, letterSpacing: 0.25, color: Colors.white),
    headline5: TextStyle(fontSize: 24, letterSpacing: 0.0, color: Colors.white),
    headline6: TextStyle(fontSize: 20, letterSpacing: 0.0, color: Colors.white, fontWeight: FontWeight.w900),
    subtitle1: TextStyle(fontSize: 16, letterSpacing: 0.0, color: Colors.white),
    subtitle2: TextStyle(fontSize: 24, letterSpacing: 0.1, color: Colors.white),
    bodyText1: TextStyle(fontSize: 16, letterSpacing: 0.1, color: Colors.white),
    bodyText2: TextStyle(fontSize: 14, letterSpacing: 0.1, color: Colors.white),
    caption: TextStyle(fontSize: 13, letterSpacing: 0.0, color: Colors.white),
    overline: TextStyle(fontSize: 10, letterSpacing: 1.5, color: Colors.white),
    button: TextStyle(fontSize: 18, letterSpacing: -0.4, color: Colors.white, fontWeight: FontWeight.w700),
  ),
  primarySwatch: primary,
  colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: const Color(0xFF5A24BE),
      primaryVariant: primary.shade500,
      secondary: const Color(0xFFED742F),
      secondaryVariant: secondary.shade500,
      error: const Color(0xffba3183),
      background: const Color(0xfffafafa),
      surface: const Color(0xfffafafa),
      onPrimary: const Color(0xff222222),
      onError: const Color(0xff222222),
      onSecondary: const Color(0xff222222),
      onBackground: const Color(0xff222222),
      onSurface: const Color(0xff222222)),
);

MaterialColor createMaterialColor(Color color) {
  List<double> strengths = [.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
