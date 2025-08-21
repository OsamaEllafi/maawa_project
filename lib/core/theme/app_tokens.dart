import 'package:flutter/material.dart';

/// Spacing tokens following 4pt grid system
class AppSpacing {
  const AppSpacing();
  
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xl2 = 24.0;
  static const double xl3 = 32.0;
  static const double xl4 = 40.0;
  static const double xl5 = 48.0;
  static const double xl6 = 64.0;
}

/// Border radius tokens
class AppRadius {
  const AppRadius();
  
  static const double xs = 2.0;
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xl2 = 20.0;
  static const double full = 9999.0;
}

/// Elevation tokens
class AppElevation {
  const AppElevation();
  
  static const double level0 = 0.0;
  static const double level1 = 1.0;
  static const double level2 = 2.0;
  static const double level3 = 4.0;
  static const double level4 = 8.0;
  static const double level5 = 16.0;
}

/// Motion/Animation duration tokens
class AppMotion {
  const AppMotion();
  
  // Micro interactions (120-240ms)
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration base = Duration(milliseconds: 150);
  static const Duration slow = Duration(milliseconds: 200);
  static const Duration slower = Duration(milliseconds: 240);
  
  // Page transitions (250-400ms)
  static const Duration pageFast = Duration(milliseconds: 250);
  static const Duration pageBase = Duration(milliseconds: 300);
  static const Duration pageSlow = Duration(milliseconds: 350);
  static const Duration pageSlower = Duration(milliseconds: 400);
  
  // Special animations
  static const Duration instant = Duration.zero;
  static const Duration quick = Duration(milliseconds: 100);
  static const Duration extended = Duration(milliseconds: 500);
  static const Duration long = Duration(seconds: 1);
}

/// Animation curves
class AppCurves {
  static const Curve standard = Curves.ease;
  static const Curve emphasized = Curves.easeInOutCubic;
  static const Curve decelerated = Curves.easeOut;
  static const Curve accelerated = Curves.easeIn;
}
