import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/language_service.dart';
import '../services/disclaimer_service.dart';
import 'jackpot_overview_screen.dart';

class DisclimberWrapper extends StatefulWidget {
  const DisclimberWrapper({super.key});

  @override
  State<DisclimberWrapper> createState() => _DisclimberWrapperState();
}

class _DisclimberWrapperState extends State<DisclimberWrapper> {
  final LanguageService _languageService = LanguageService();
  final DisclaimerService _disclaimerService = DisclaimerService();
  bool _accepted = false;
  bool _checkingDisclaimer = true;

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onUpdate);
    _checkDisclaimerStatus();
  }

  @override
  void dispose() {
    _languageService.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    setState(() {});
  }

  Future<void> _checkDisclaimerStatus() async {
    final isAccepted = await _disclaimerService.isDisclaimerAccepted();
    if (mounted) {
      setState(() {
        _accepted = isAccepted;
        _checkingDisclaimer = false;
      });
    }
  }

  void _handleAccept() async {
    await _disclaimerService.setDisclaimerAccepted();
    if (mounted) {
      setState(() {
        _accepted = true;
      });
    }
  }

  void _handleDecline() {
    // App komplett schließen
    SystemNavigator.pop();
  }

  void _switchLanguage() {
    _languageService.switchLanguage();
  }

  String _getFlagEmoji(String language) {
    switch (language) {
      case 'de': return '🇩🇪';
      case 'en': return '🇺🇸';
      case 'tr': return '🇹🇷';
      default: return '🌐';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingDisclaimer) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_accepted) {
      final texts = DisclaimerService.getDisclaimerTexts(_languageService.currentLanguage);
      
      return Scaffold(
        backgroundColor: Colors.black54,
        appBar: AppBar(
          title: const Text('Lotto World Pro'),
          actions: [
            IconButton(
              icon: Text(_getFlagEmoji(_languageService.currentLanguage)),
              onPressed: _switchLanguage,
              tooltip: 'Sprache wechseln / Change language / Dil değiştir',
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: AlertDialog(
              title: Text(texts['title']!),
              content: Text(texts['content']!),
              actions: [
                TextButton(
                  onPressed: _handleDecline,
                  child: Text(texts['decline']!),
                ),
                ElevatedButton(
                  onPressed: _handleAccept,
                  child: Text(texts['accept']!),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const JackpotOverviewScreen();
  }
}
