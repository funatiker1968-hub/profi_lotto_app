import 'package:flutter/material.dart';
import '../services/language_service.dart';
import 'jackpot_overview_screen.dart';

class DisclimberWrapper extends StatefulWidget {
  const DisclimberWrapper({super.key});

  @override
  State<DisclimberWrapper> createState() => _DisclimberWrapperState();
}

class _DisclimberWrapperState extends State<DisclimberWrapper> {
  final LanguageService _languageService = LanguageService();
  bool _accepted = false;

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _languageService.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    setState(() {});
  }

  void _acceptDisclaimer() {
    setState(() {
      _accepted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_accepted) {
      return const JackpotOverviewScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_languageService.getTranslation('disclaimerTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              _languageService.switchLanguage();
            },
            tooltip: 'Sprache wechseln',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Einfacher Disclaimer-Text
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.warning, size: 48, color: Colors.orange),
                    const SizedBox(height: 16),
                    Text(
                      _getDisclaimerText(),
                      style: const TextStyle(fontSize: 16, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Akzeptieren Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: Text(
                  _languageService.getTranslation('accept'),
                  style: const TextStyle(fontSize: 18),
                ),
                onPressed: _acceptDisclaimer,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDisclaimerText() {
    switch (_languageService.currentLanguage) {
      case 'de':
        return 'Diese App dient Unterhaltungszwecken. Lotto ist ein Glücksspiel. Sie bestätigen, das Mindestalter erreicht zu haben.';
      case 'en':
        return 'This app is for entertainment purposes. Lotto is a game of chance. You confirm you have reached the minimum age.';
      case 'tr':
        return 'Bu uygulama eğlence amaçlıdır. Loto bir şans oyunudur. Asgari yaşa ulaştığınızı onaylıyorsunuz.';
      default:
        return 'This app is for entertainment purposes.';
    }
  }
}
