import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.trips),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Trips Screen - Coming Soon'),
      ),
    );
  }
}
