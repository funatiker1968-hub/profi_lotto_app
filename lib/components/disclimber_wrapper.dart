import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import 'jackpot_overview_screen.dart';

class DisclimberWrapper extends StatefulWidget {
  const DisclimberWrapper({super.key});

  @override
  State<DisclimberWrapper> createState() => _DisclimberWrapperState();
}

class _DisclimberWrapperState extends State<DisclimberWrapper> {
  final LanguageService _languageService = LanguageService();
  final ThemeService _themeService = ThemeService();
  bool _disclaimerAccepted = false;

  void _acceptDisclaimer() {
    setState(() {
      _disclaimerAccepted = true;
    });
  }

  void _declineDisclaimer() {
    SystemNavigator.pop(); // App beenden
  }

  void _switchLanguage() {
    _languageService.switchLanguage();
    setState(() {});
  }

  void _switchTheme() {
    _themeService.switchTheme();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_disclaimerAccepted) {
      return const JackpotOverviewScreen();
    }

    return MaterialApp(
      theme: _themeService.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_languageService.getTranslation('disclaimerTitle')),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: _switchLanguage,
              tooltip: 'Sprache wechseln',
            ),
            IconButton(
              icon: Icon(_themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: _switchTheme,
              tooltip: 'Theme wechseln',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.warning_amber,
                size: 64,
                color: Colors.orange,
              ),
              const SizedBox(height: 20),
              Text(
                _languageService.getTranslation('disclaimerTitle'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Diese App dient ausschließlich Unterhaltungszwecken. '
                    'Lotto-Spiele basieren auf Glück und es gibt keine Garantie für Gewinne. '
                    'Spiele verantwortungsbewusst und nur mit Geld, das du dir leisten kannst zu verlieren. '
                    'Der Entwickler übernimmt keine Haftung für finanzielle Verluste.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _declineDisclaimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(_languageService.getTranslation('decline')),
                  ),
                  ElevatedButton(
                    onPressed: _acceptDisclaimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    child: Text(_languageService.getTranslation('accept')),
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
