import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.explore),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Explore Screen - Coming Soon'),
      ),
    );
  }
}
