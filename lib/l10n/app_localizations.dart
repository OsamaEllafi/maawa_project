import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ar', 'SA'),
  ];

  // Common
  String get appName => _localizedValues[locale.languageCode]!['app_name']!;
  String get welcome => _localizedValues[locale.languageCode]!['welcome']!;
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get search => _localizedValues[locale.languageCode]!['search']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;

  // Navigation
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get explore => _localizedValues[locale.languageCode]!['explore']!;
  String get favorites => _localizedValues[locale.languageCode]!['favorites']!;
  String get trips => _localizedValues[locale.languageCode]!['trips']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;

  // Property related
  String get properties =>
      _localizedValues[locale.languageCode]!['properties']!;
  String get property => _localizedValues[locale.languageCode]!['property']!;
  String get rent => _localizedValues[locale.languageCode]!['rent']!;
  String get price => _localizedValues[locale.languageCode]!['price']!;
  String get location => _localizedValues[locale.languageCode]!['location']!;
  String get bedrooms => _localizedValues[locale.languageCode]!['bedrooms']!;
  String get bathrooms => _localizedValues[locale.languageCode]!['bathrooms']!;
  String get area => _localizedValues[locale.languageCode]!['area']!;

  // User roles
  String get admin => _localizedValues[locale.languageCode]!['admin']!;
  String get owner => _localizedValues[locale.languageCode]!['owner']!;
  String get tenant => _localizedValues[locale.languageCode]!['tenant']!;

  // Theme and settings
  String get theme => _localizedValues[locale.languageCode]!['theme']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get lightMode => _localizedValues[locale.languageCode]!['lightMode']!;
  String get darkMode => _localizedValues[locale.languageCode]!['darkMode']!;
  String get systemMode =>
      _localizedValues[locale.languageCode]!['systemMode']!;
  String get about => _localizedValues[locale.languageCode]!['about']!;

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'MAAWA',
      'welcome': 'Welcome to MAAWA',
      'login': 'Login',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'search': 'Search',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'loading': 'Loading...',
      'home': 'Home',
      'explore': 'Explore',
      'favorites': 'Favorites',
      'trips': 'Trips',
      'profile': 'Profile',
      'properties': 'Properties',
      'property': 'Property',
      'rent': 'Rent',
      'price': 'Price',
      'location': 'Location',
      'bedrooms': 'Bedrooms',
      'bathrooms': 'Bathrooms',
      'area': 'Area',
      'admin': 'Admin',
      'owner': 'Property Owner',
      'tenant': 'Tenant',
      'theme': 'Theme',
      'language': 'Language',
      'lightMode': 'Light Mode',
      'darkMode': 'Dark Mode',
      'systemMode': 'System Mode',
      'about': 'About',
    },
    'ar': {
      'app_name': 'مأوى',
      'welcome': 'مرحباً بك في مأوى',
      'login': 'تسجيل الدخول',
      'logout': 'تسجيل الخروج',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'search': 'بحث',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'loading': 'جاري التحميل...',
      'home': 'الرئيسية',
      'explore': 'استكشاف',
      'favorites': 'المفضلة',
      'trips': 'الرحلات',
      'profile': 'الملف الشخصي',
      'properties': 'العقارات',
      'property': 'عقار',
      'rent': 'إيجار',
      'price': 'السعر',
      'location': 'الموقع',
      'bedrooms': 'غرف النوم',
      'bathrooms': 'دورات المياه',
      'area': 'المساحة',
      'admin': 'مدير',
      'owner': 'مالك العقار',
      'tenant': 'مستأجر',
      'theme': 'المظهر',
      'language': 'اللغة',
      'lightMode': 'المظهر الفاتح',
      'darkMode': 'المظهر الداكن',
      'systemMode': 'مظهر النظام',
      'about': 'حول',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
