with open('lib/services/language_service.dart', 'r') as f:
    content = f.read()

# Prüfe ob LanguageService ein Singleton ist und NotifyListener hat
if 'static final LanguageService _instance = LanguageService._internal();' not in content:
    # Mache LanguageService zu einem Singleton mit ChangeNotifier
    new_content = '''import 'package:flutter/foundation.dart';

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
      // Weitere Übersetzungen...
    },
    'en': {
      'appTitle': 'Lotto World Pro', 
      'disclaimerTitle': 'Disclaimer',
      'accept': 'Accept',
      'decline': 'Decline',
      // Weitere Übersetzungen...
    },
    'tr': {
      'appTitle': 'Lotto World Pro',
      'disclaimerTitle': 'Sorumluluk Reddi',
      'accept': 'Kabul Et', 
      'decline': 'Reddet',
      // Weitere Übersetzungen...
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
}'''
    
    with open('lib/services/language_service.dart', 'w') as f:
        f.write(new_content)
    print("✅ LanguageService als Singleton mit ChangeNotifier repariert")
else:
    print("ℹ️ LanguageService bereits korrekt implementiert")
