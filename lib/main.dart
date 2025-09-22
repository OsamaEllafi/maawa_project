import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/config/app_config.dart';
import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'l10n/app_localizations.dart';
import 'app/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app configuration
  await AppConfig.initialize();

  // Initialize service locator
  await ServiceLocator().initialize();

  runApp(const MaawaApp());
}

class MaawaApp extends StatelessWidget {
  const MaawaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: ServiceLocator.getProviders(),
      child: Consumer2<AuthProvider, ThemeProvider>(
        builder: (context, authProvider, themeProvider, _) {
          print(
            '🔄 MaawaApp: Rebuilding with authProvider.isAuthenticated = ${authProvider.isAuthenticated}',
          );
          return MaterialApp.router(
            title: 'MAAWA',
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: AppTheme.lightTheme('en'),
            darkTheme: AppTheme.darkTheme('en'),
            themeMode: themeProvider.themeMode == AppThemeMode.dark
                ? ThemeMode.dark
                : themeProvider.themeMode == AppThemeMode.light
                ? ThemeMode.light
                : ThemeMode.system,

            // Localization configuration
            locale: const Locale('en'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,

            // Router configuration
            routerConfig: AppRouter.createRouter(authProvider),
          );
        },
      ),
    );
  }
}
