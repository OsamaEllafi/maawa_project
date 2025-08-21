import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeMode {
  light,
  dark,
  system,
}

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language_code';
  
  ThemeMode _themeMode = ThemeMode.system;
  String _languageCode = 'en';
  bool _isRTL = false;

  ThemeMode get themeMode => _themeMode;
  String get languageCode => _languageCode;
  bool get isRTL => _isRTL;
  Locale get locale => Locale(_languageCode);

  ThemeProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey) ?? 2; // Default to system
    final language = prefs.getString(_languageKey) ?? 'en';
    
    _themeMode = ThemeMode.values[themeIndex];
    _languageCode = language;
    _isRTL = language == 'ar';
    
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
    
    notifyListeners();
  }

  Future<void> setLanguage(String languageCode) async {
    if (_languageCode == languageCode) return;
    
    _languageCode = languageCode;
    _isRTL = languageCode == 'ar';
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    
    notifyListeners();
  }

  bool get isDarkMode {
    switch (_themeMode) {
      case ThemeMode.light:
        return false;
      case ThemeMode.dark:
        return true;
      case ThemeMode.system:
        final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
        return brightness == Brightness.dark;
    }
  }

  String get themeModeName {
    switch (_themeMode) {
      case ThemeMode.light:
        return _languageCode == 'ar' ? 'المظهر الفاتح' : 'Light Mode';
      case ThemeMode.dark:
        return _languageCode == 'ar' ? 'المظهر الداكن' : 'Dark Mode';
      case ThemeMode.system:
        return _languageCode == 'ar' ? 'مظهر النظام' : 'System Mode';
    }
  }

  String get languageName {
    switch (_languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return 'English';
    }
  }

  List<Map<String, dynamic>> get availableLanguages => [
    {
      'code': 'en',
      'name': 'English',
      'nativeName': 'English',
      'isRTL': false,
    },
    {
      'code': 'ar',
      'name': 'Arabic',
      'nativeName': 'العربية',
      'isRTL': true,
    },
  ];

  List<Map<String, dynamic>> get availableThemes => [
    {
      'mode': ThemeMode.light,
      'name': _languageCode == 'ar' ? 'المظهر الفاتح' : 'Light Mode',
      'icon': Icons.light_mode,
    },
    {
      'mode': ThemeMode.dark,
      'name': _languageCode == 'ar' ? 'المظهر الداكن' : 'Dark Mode',
      'icon': Icons.dark_mode,
    },
    {
      'mode': ThemeMode.system,
      'name': _languageCode == 'ar' ? 'مظهر النظام' : 'System Mode',
      'icon': Icons.settings_system_daydream,
    },
  ];
}
