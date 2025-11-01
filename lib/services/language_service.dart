import 'package:flutter/foundation.dart';

class LanguageService with ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  String _currentLanguage = 'de';
  final Map<String, Map<String, String>> _translations = {
    'de': {
      'appTitle': 'Lotto World Pro',
      'disclaimerTitle': 'Haftungsausschluss',
      'accept': 'Akzeptieren',
      'decline': 'Ablehnen',
      'yourTip': 'Dein Tipp:',
      'newTip': 'Neuer Tipp',
      'clearAll': 'Alle löschen',
      'tipHistory': 'Tipp-Historie:',
      'noTipsSaved': 'Noch keine Tipps gespeichert.',
      'created': 'Erstellt',
      'mainNumbers': 'Hauptzahlen',
      'bonusNumbers': 'Bonus-Zahlen',
      'superNumber': 'Superzahl',
      'euroNumbers': 'Eurozahlen',
    },
    'en': {
      'appTitle': 'Lotto World Pro',
      'disclaimerTitle': 'Disclaimer',
      'accept': 'Accept',
      'decline': 'Decline',
      'yourTip': 'Your Tip:',
      'newTip': 'New Tip',
      'clearAll': 'Clear All',
      'tipHistory': 'Tip History:',
      'noTipsSaved': 'No tips saved yet.',
      'created': 'Created',
      'mainNumbers': 'Main Numbers',
      'bonusNumbers': 'Bonus Numbers',
      'superNumber': 'Super Number',
      'euroNumbers': 'Euro Numbers',
    },
    'tr': {
      'appTitle': 'Lotto World Pro',
      'disclaimerTitle': 'Sorumluluk Reddi',
      'accept': 'Kabul Et',
      'decline': 'Reddet',
      'yourTip': 'Tahmininiz:',
      'newTip': 'Yeni Tahmin',
      'clearAll': 'Hepsini Sil',
      'tipHistory': 'Tahmin Geçmişi:',
      'noTipsSaved': 'Henüz tahmin kaydedilmedi.',
      'created': 'Oluşturuldu',
      'mainNumbers': 'Ana Numara',
      'bonusNumbers': 'Bonus Numara',
      'superNumber': 'Süper Numara',
      'euroNumbers': 'Euro Numara',
    },
  };

  String get currentLanguage => _currentLanguage;

  void switchLanguage() {
    if (_currentLanguage == 'de') {
      _currentLanguage = 'en';
    } else if (_currentLanguage == 'en') {
      _currentLanguage = 'tr';
    } else {
      _currentLanguage = 'de';
    }
    notifyListeners();
  }

  String getTranslation(String key) {
    return _translations[_currentLanguage]?[key] ?? key;
  }
}
