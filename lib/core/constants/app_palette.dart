import 'package:flutter/material.dart';

abstract final class AppLightPalette {
  // Base colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F7FF);

  // Text colors
  static const Color text1 = Color(0xFF1C1B1B);
  static const Color text2 = Color(0xFF494454);
  static const Color text3 = Color(0xFF7B7486);

  // Brand colors
  static const Color lightPurple = Color(0xFF5312BC);
  static const Color purple = Color(0xFF6B38D4);
  static const Color paleViolet = Color(0xFFD0BCFF);

  // UI colors
  static const Color appBarBackground = Color(0xFFFCF9F8);
  static const Color red = Color(0xFFBA1A1A);
  static const Color dividerColor = Color(0xFFE4E2E1);
  static const Color borderColor = Color(0xFFCBC3D7);
  static const Color navBarBackground = Color(0xFFCBC3D7);

  // Gradient
  static Gradient primaryGradient = LinearGradient(
    colors: <Color>[purple, paleViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

abstract final class AppDarkPalette {
  // Base colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFF121116);

  // Text colors
  static const Color text1 = Color(0xFFF5F2F7);
  static const Color text2 = Color(0xFFD0CAD6);
  static const Color text3 = Color(0xFF9A929F);

  // Brand colors
  static const Color lightPurple = Color(0xFF7C3AED);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color paleViolet = Color(0xFFD0BCFF);

  // UI colors
  static const Color appBarBackground = Color(0xFF1A181F);
  static const Color red = Color(0xFFFF6B6B);
  static const Color dividerColor = Color(0xFF302C35);
  static const Color borderColor = Color(0xFF48414F);

  // Liquid Glass navigation
  static const Color navBarBackground = Color(0xFF29242F);

  // Gradient
  static const Gradient primaryGradient = LinearGradient(
    colors: <Color>[Color(0xFF5312BC), Color(0xFF8B5CF6), Color(0xFFD0BCFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
