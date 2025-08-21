import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../../l10n/app_localizations.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/home/screens/main_navigation_screen.dart';

class AppShell extends ChangeNotifier {
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.system;

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  bool get isRTL => _locale.languageCode == 'ar';

  void setLocale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
    }
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  void toggleTheme() {
    switch (_themeMode) {
      case ThemeMode.light:
        setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        setThemeMode(ThemeMode.system);
        break;
      case ThemeMode.system:
        setThemeMode(ThemeMode.light);
        break;
    }
  }

  void toggleLanguage() {
    setLocale(_locale.languageCode == 'en' 
        ? const Locale('ar') 
        : const Locale('en'));
  }

  String getThemeModeLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return 'Theme';
    switch (_themeMode) {
      case ThemeMode.light:
        return l10n.lightMode;
      case ThemeMode.dark:
        return l10n.darkMode;
      case ThemeMode.system:
        return l10n.systemMode;
    }
  }

  String getLanguageLabel() {
    return _locale.languageCode == 'en' ? 'English' : 'العربية';
  }
}

class MaawaAppShell extends StatelessWidget {
  const MaawaAppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => AppShell()),
      ],
      child: Consumer2<AuthService, AppShell>(
        builder: (context, authService, appShell, _) {
          return MaterialApp(
            title: 'MAAWA',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme(appShell.locale.languageCode),
            darkTheme: AppTheme.darkTheme(appShell.locale.languageCode),
            themeMode: appShell.themeMode,
            locale: appShell.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) {
              // Handle RTL layout direction
              return Directionality(
                textDirection: appShell.isRTL 
                    ? TextDirection.rtl 
                    : TextDirection.ltr,
                child: child!,
              );
            },
            home: authService.isAuthenticated 
                ? const MainNavigationScreen()
                : const LoginScreen(),
          );
        },
      ),
    );
  }
}

// Settings widget for theme and language controls
class AppSettingsWidget extends StatelessWidget {
  const AppSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appShell = Provider.of<AppShell>(context);
    final l10n = AppLocalizations.of(context);
    
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: Text(l10n?.theme ?? 'Theme'),
          subtitle: Text(appShell.getThemeModeLabel(context)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThemeDialog(context),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: Text(l10n?.language ?? 'Language'),
          subtitle: Text(appShell.getLanguageLabel()),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showLanguageDialog(context),
        ),
      ],
    );
  }

  void _showThemeDialog(BuildContext context) {
    final appShell = Provider.of<AppShell>(context, listen: false);
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.theme ?? 'Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n?.lightMode ?? 'Light Mode'),
              value: ThemeMode.light,
              groupValue: appShell.themeMode,
              onChanged: (value) {
                appShell.setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n?.darkMode ?? 'Dark Mode'),
              value: ThemeMode.dark,
              groupValue: appShell.themeMode,
              onChanged: (value) {
                appShell.setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n?.systemMode ?? 'System Mode'),
              value: ThemeMode.system,
              groupValue: appShell.themeMode,
              onChanged: (value) {
                appShell.setThemeMode(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final appShell = Provider.of<AppShell>(context, listen: false);
    final l10n = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n?.language ?? 'Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Locale>(
              title: const Text('English'),
              value: const Locale('en'),
              groupValue: appShell.locale,
              onChanged: (value) {
                appShell.setLocale(value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile<Locale>(
              title: const Text('العربية'),
              value: const Locale('ar'),
              groupValue: appShell.locale,
              onChanged: (value) {
                appShell.setLocale(value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
        ],
      ),
    );
  }
}

// Quick toggle buttons for theme and language
class QuickToggleButtons extends StatelessWidget {
  const QuickToggleButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final appShell = Provider.of<AppShell>(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(_getThemeIcon(appShell.themeMode)),
          tooltip: appShell.getThemeModeLabel(context),
          onPressed: appShell.toggleTheme,
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.language),
          tooltip: appShell.getLanguageLabel(),
          onPressed: appShell.toggleLanguage,
        ),
      ],
    );
  }

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
