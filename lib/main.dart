import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/services/auth_service.dart';
import 'core/services/app_shell.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'app/navigation/app_router.dart';

void main() {
  runApp(const MaawaApp());
}

class MaawaApp extends StatelessWidget {
  const MaawaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => AppShell()),
      ],
      child: Consumer<AppShell>(
        builder: (context, appShell, _) {
          final authService = Provider.of<AuthService>(context, listen: false);
          return MaterialApp.router(
            title: 'MAAWA',
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: AppTheme.lightTheme(appShell.locale.languageCode),
            darkTheme: AppTheme.darkTheme(appShell.locale.languageCode),
            themeMode: appShell.themeMode,

            // Localization configuration
            locale: appShell.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,

            // RTL support
            builder: (context, child) {
              return Directionality(
                textDirection: appShell.isRTL
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: child!,
              );
            },

            // Router configuration
            routerConfig: AppRouter.createRouter(authService),
          );
        },
      ),
    );
  }
}
