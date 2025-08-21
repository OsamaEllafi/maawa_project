import 'package:flutter/material.dart';

/// MAAWA App Colors - Derived from brand logos with AA contrast compliance
class AppColors {
  // Brand gradient colors from logos
  static const Color primaryCoral = Color(0xFFFF6B6B);
  static const Color primaryMagenta = Color(0xFFE91E63);
  static const Color primaryTurquoise = Color(0xFF26C6DA);
  static const Color primaryOrange = Color(0xFFFF8A65);

  // Light theme colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1A1A1A);
  static const Color lightOnBackground = Color(0xFF2C2C2C);
  static const Color lightSecondary = Color(0xFF757575);
  static const Color lightTertiary = Color(0xFF9E9E9E);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnSurface = Color(0xFFE0E0E0);
  static const Color darkOnBackground = Color(0xFFFFFFFF);
  static const Color darkSecondary = Color(0xFFB0B0B0);
  static const Color darkTertiary = Color(0xFF808080);

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF2196F3);

  // Neutral grays
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  // Brand gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryOrange, primaryCoral, primaryMagenta],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [primaryTurquoise, Color(0xFF00BCD4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadow colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
}
