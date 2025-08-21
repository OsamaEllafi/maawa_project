import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.favorites),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Favorites Screen - Coming Soon'),
      ),
    );
  }
}
