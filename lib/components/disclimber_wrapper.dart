import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import 'jackpot_overview_screen.dart';

class DisclimberWrapper extends StatefulWidget {
  const DisclimberWrapper({super.key});

  @override
  State<DisclimberWrapper> createState() => _DisclimberWrapperState();
}

class _DisclimberWrapperState extends State<DisclimberWrapper> {
  bool _disclaimerAccepted = false;
  final LanguageService _languageService = LanguageService();
  final ThemeService _themeService = ThemeService();

  void _handleDisclaimerAccept() {
    setState(() {
      _disclaimerAccepted = true;
    });
  }

  void _switchLanguage() {
    setState(() {
      _languageService.switchLanguage();
    });
  }

  void _switchTheme() {
    setState(() {
      _themeService.switchTheme();
    });
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('App verlassen'),
          content: const Text('Möchtest du die App wirklich verlassen?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Verlassen'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_disclaimerAccepted) {
      return _buildDisclaimerScreen();
    }

    // Nach Disclaimer direkt zum Hauptscreen mit Jackpot-Übersicht
    return const JackpotOverviewScreen();
  }

  Widget _buildDisclaimerScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_languageService.getTranslation('appTitle')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _switchLanguage,
            tooltip: 'Sprache wechseln (${_languageService.getCurrentLanguageName()})',
          ),
          IconButton(
            icon: Icon(_themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _switchTheme,
            tooltip: _themeService.isDarkMode ? 'Hell Modus' : 'Dunkel Modus',
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _showExitDialog(context),
            tooltip: 'App verlassen',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber, size: 64, color: Colors.orange),
              const SizedBox(height: 24),
              Text(
                _languageService.getTranslation('disclaimerTitle'),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                _languageService.getTranslation('disclaimerText'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showExitDialog(context),
                      child: Text(_languageService.getTranslation('decline')),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleDisclaimerAccept,
                      child: Text(_languageService.getTranslation('accept')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
