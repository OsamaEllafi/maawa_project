import 'package:flutter/material.dart';

class BrandConstants {
  // Logo assets
  static const String logoPrimary = 'frontend/assets/branding/Logo1.png';
  static const String logoWhite = 'frontend/assets/branding/Logo1.png'; // Same for now
  static const String logoDark = 'frontend/assets/branding/Logo1.png'; // Same for now
  static const String logoSmall = 'frontend/assets/branding/Logo1.png'; // Same for now
  static const String logoLarge = 'frontend/assets/branding/Logo1.png'; // Same for now

  // Logo sizes
  static const double logoSizeSmall = 24.0;
  static const double logoSizeMedium = 32.0;
  static const double logoSizeLarge = 48.0;
  static const double logoSizeXLarge = 64.0;
  static const double logoSizeXXLarge = 96.0;

  // App name and tagline
  static const String appName = 'MAAWA';
  static const String appNameArabic = 'معاوا';
  static const String appTagline = 'Your Home Away From Home';
  static const String appTaglineArabic = 'منزلك بعيداً عن المنزل';
  static const String appDescription = 'Discover and book unique accommodations in Libya';
  static const String appDescriptionArabic = 'اكتشف واحجز إقامات فريدة في ليبيا';

  // Brand colors (from app_colors.dart)
  static const Color primaryCoral = Color(0xFFFF6B6B);
  static const Color primaryMagenta = Color(0xFFE91E63);
  static const Color primaryTurquoise = Color(0xFF26A69A);
  static const Color secondaryCoral = Color(0xFFFF8A80);
  static const Color accentBlue = Color(0xFF2196F3);

  // Brand typography
  static const String primaryFontFamily = 'Inter';
  static const String arabicFontFamily = 'Almarai';
  static const double headingFontSize = 24.0;
  static const double subheadingFontSize = 18.0;
  static const double bodyFontSize = 16.0;
  static const double captionFontSize = 14.0;

  // Brand spacing
  static const double brandSpacingSmall = 8.0;
  static const double brandSpacingMedium = 16.0;
  static const double brandSpacingLarge = 24.0;
  static const double brandSpacingXLarge = 32.0;

  // Brand border radius
  static const double brandBorderRadiusSmall = 4.0;
  static const double brandBorderRadiusMedium = 8.0;
  static const double brandBorderRadiusLarge = 12.0;
  static const double brandBorderRadiusXLarge = 16.0;

  // Brand shadows
  static const List<BoxShadow> brandShadowLight = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 4,
    ),
  ];

  static const List<BoxShadow> brandShadowMedium = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
  ];

  static const List<BoxShadow> brandShadowHeavy = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 8),
      blurRadius: 16,
    ),
  ];

  // Brand gradients
  static const LinearGradient brandGradientPrimary = LinearGradient(
    colors: [primaryCoral, primaryMagenta],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient brandGradientSecondary = LinearGradient(
    colors: [primaryTurquoise, accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient brandGradientAccent = LinearGradient(
    colors: [primaryCoral, primaryTurquoise],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Brand icons
  static const IconData brandIconHome = Icons.home;
  static const IconData brandIconSearch = Icons.search;
  static const IconData brandIconHeart = Icons.favorite;
  static const IconData brandIconUser = Icons.person;
  static const IconData brandIconSettings = Icons.settings;
  static const IconData brandIconLocation = Icons.location_on;
  static const IconData brandIconStar = Icons.star;
  static const IconData brandIconCalendar = Icons.calendar_today;
  static const IconData brandIconPayment = Icons.payment;
  static const IconData brandIconNotification = Icons.notifications;

  // Brand animations
  static const Duration brandAnimationFast = Duration(milliseconds: 150);
  static const Duration brandAnimationMedium = Duration(milliseconds: 300);
  static const Duration brandAnimationSlow = Duration(milliseconds: 500);

  // Brand curves
  static const Curve brandCurveEase = Curves.easeInOut;
  static const Curve brandCurveBounce = Curves.bounceOut;
  static const Curve brandCurveElastic = Curves.elasticOut;

  // Brand usage guidelines
  static const Map<String, String> usageGuidelines = {
    'logo': 'Use the logo with proper spacing and never distort its proportions',
    'colors': 'Use brand colors consistently across all touchpoints',
    'typography': 'Use the specified font families and sizes for consistency',
    'spacing': 'Follow the 8pt grid system for consistent spacing',
    'animations': 'Use brand animation durations and curves for smooth interactions',
  };

  // Brand voice and tone
  static const Map<String, String> brandVoice = {
    'friendly': 'Warm and welcoming, like a trusted friend',
    'professional': 'Reliable and trustworthy, like a professional service',
    'helpful': 'Supportive and informative, always ready to assist',
    'local': 'Connected to Libyan culture and community',
  };

  // Brand values
  static const List<String> brandValues = [
    'Trust',
    'Community',
    'Quality',
    'Innovation',
    'Local Pride',
  ];

  // Contact information
  static const String brandEmail = 'hello@maawa.ly';
  static const String brandPhone = '+218 XXX XXX XXX';
  static const String brandWebsite = 'https://maawa.ly';
  static const String brandAddress = 'Tripoli, Libya';

  // Social media
  static const String brandFacebook = 'https://facebook.com/maawa';
  static const String brandInstagram = 'https://instagram.com/maawa';
  static const String brandTwitter = 'https://twitter.com/maawa';
  static const String brandLinkedIn = 'https://linkedin.com/company/maawa';

  // Legal information
  static const String brandCopyright = '© 2024 MAAWA. All rights reserved.';
  static const String brandPrivacyPolicy = 'https://maawa.ly/privacy';
  static const String brandTermsOfService = 'https://maawa.ly/terms';
  static const String brandCookiePolicy = 'https://maawa.ly/cookies';

  // App store links
  static const String appStoreLink = 'https://apps.apple.com/app/maawa';
  static const String playStoreLink = 'https://play.google.com/store/apps/details?id=com.maawa.app';

  // Version information
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appVersionName = 'MAAWA v$appVersion';

  // Feature flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePushNotifications = true;
  static const bool enableLocationServices = true;
  static const bool enableBiometricAuth = true;

  // API configuration
  static const String apiBaseUrl = 'https://api.maawa.ly';
  static const String apiVersion = 'v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int apiRetryAttempts = 3;

  // Cache configuration
  static const Duration imageCacheDuration = Duration(days: 7);
  static const Duration dataCacheDuration = Duration(hours: 24);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB

  // Performance thresholds
  static const Duration maxLoadTime = Duration(seconds: 3);
  static const Duration maxAnimationDuration = Duration(milliseconds: 500);
  static const double minFrameRate = 60.0;

  // Accessibility thresholds
  static const double minContrastRatio = 4.5;
  static const double minTouchTargetSize = 44.0;
  static const double minTextSize = 12.0;
  static const double maxTextScaleFactor = 2.0;
}
