import 'package:flutter/material.dart';
import '../services/lotto_system_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import 'system_selection_screen.dart';
import 'lotto_tip_screen.dart';

class DisclimberWrapper extends StatefulWidget {
  const DisclimberWrapper({super.key});

  @override
  State<DisclimberWrapper> createState() => _DisclimberWrapperState();
}

class _DisclimberWrapperState extends State<DisclimberWrapper> {
  bool _disclaimerAccepted = false;
  LottoSystem? _selectedSystem;
  final LanguageService _languageService = LanguageService();
  final ThemeService _themeService = ThemeService();

  void _handleDisclaimerAccept() {
    setState(() {
      _disclaimerAccepted = true;
    });
  }

  void _handleSystemSelected(LottoSystem system) {
    setState(() {
      _selectedSystem = system;
    });
  }

  void _handleBackToSystemSelection() {
    setState(() {
      _selectedSystem = null;
    });
  }

  void _handleBackToDisclaimer() {
    setState(() {
      _selectedSystem = null;
      _disclaimerAccepted = false;
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

  @override
  Widget build(BuildContext context) {
    if (!_disclaimerAccepted) {
      return _buildDisclaimerScreen();
    }

    if (_selectedSystem == null) {
      return SystemSelectionScreen(
        onSystemSelected: _handleSystemSelected,
        onBack: _handleBackToDisclaimer,
      );
    }

    return LottoTipScreen(
      selectedSystem: _selectedSystem!,
      onBack: _handleBackToSystemSelection,
    );
  }

  Widget _buildDisclaimerScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_languageService.getTranslation('appTitle')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          // Sprachumschaltung
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _switchLanguage,
            tooltip: 'Sprache wechseln (${_languageService.getCurrentLanguageName()})',
          ),
          // Theme Umschaltung
          IconButton(
            icon: Icon(_themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _switchTheme,
            tooltip: _themeService.isDarkMode ? 'Hell Modus' : 'Dunkel Modus',
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
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
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
