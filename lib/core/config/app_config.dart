import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Environment { production, lan }

class AppConfig {
  static const String _baseUrlKey = 'base_url_environment';

  // Default URLs from Postman collection
  static const String _productionUrl =
      'https://phplaravel-1509831-5796792.cloudwaysapps.com';
  static const String _lanUrl = 'http://192.168.1.100:8000';

  static Environment _currentEnvironment = Environment.production;

  static Environment get currentEnvironment => _currentEnvironment;

  static String get baseUrl {
    switch (_currentEnvironment) {
      case Environment.production:
        return _productionUrl;
      case Environment.lan:
        return _lanUrl;
    }
  }

  static String get apiBaseUrl => '$baseUrl/api';

  static bool get isDebug => kDebugMode;

  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final environmentIndex = prefs.getInt(_baseUrlKey) ?? 0;
    _currentEnvironment = Environment.values[environmentIndex];
  }

  static Future<void> setEnvironment(Environment environment) async {
    _currentEnvironment = environment;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_baseUrlKey, environment.index);
  }

  static String getEnvironmentName(Environment environment) {
    switch (environment) {
      case Environment.production:
        return 'Production';
      case Environment.lan:
        return 'LAN';
    }
  }

  static List<Environment> get availableEnvironments => Environment.values;
}
