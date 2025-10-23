import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static const String _languageKey = 'appLanguage';
  
  static const Map<String, Map<String, String>> _translations = {
    'de': {
      'appTitle': 'Lotto World Pro',
      'generateTip': 'Tipp generieren',
      'saveTip': 'Tipp speichern',
      'currentTip': 'Aktueller Tipp',
      'noTip': 'Kein Tipp generiert',
      'savedTips': 'Gespeicherte Tipps',
      'noSavedTips': 'Keine gespeicherten Tipps',
      'deleteAll': 'Alle Tipps löschen',
      'stats': 'Statistiken',
      'analysis': 'Analyse',
      'darkMode': 'Dark Mode',
      'lightMode': 'Light Mode',
      'created': 'Erstellt',
      'currentLanguage': 'Aktuelle Sprache',
      'hotNumbers': 'Heiße Zahlen',
      'coldNumbers': 'Kalte Zahlen',
      'numberStats': 'Zahlen Statistiken',
    },
    'en': {
      'appTitle': 'Lotto World Pro',
      'generateTip': 'Generate Tip',
      'saveTip': 'Save Tip',
      'currentTip': 'Current Tip',
      'noTip': 'No tip generated',
      'savedTips': 'Saved Tips',
      'noSavedTips': 'No saved tips',
      'deleteAll': 'Delete All Tips',
      'stats': 'Statistics',
      'analysis': 'Analysis',
      'darkMode': 'Dark Mode',
      'lightMode': 'Light Mode',
      'created': 'Created',
      'currentLanguage': 'Current Language',
      'hotNumbers': 'Hot Numbers',
      'coldNumbers': 'Cold Numbers',
      'numberStats': 'Number Statistics',
    },
    'tr': {
      'appTitle': 'Lotto World Pro',
      'generateTip': 'Tahmin Oluştur',
      'saveTip': 'Tahmini Kaydet',
      'currentTip': 'Mevcut Tahmin',
      'noTip': 'Tahmin oluşturulmadı',
      'savedTips': 'Kayıtlı Tahminler',
      'noSavedTips': 'Kayıtlı tahmin yok',
      'deleteAll': 'Tüm Tahminleri Sil',
      'stats': 'İstatistikler',
      'analysis': 'Analiz',
      'darkMode': 'Karanlık Mod',
      'lightMode': 'Aydınlık Mod',
      'created': 'Oluşturulma',
      'currentLanguage': 'Geçerli Dil',
      'hotNumbers': 'Sıcak Numaralar',
      'coldNumbers': 'Soğuk Numaralar',
      'numberStats': 'Numara İstatistikleri',
    },
  };

  Future<String> getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'de';
  }

  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  String translate(String key, String language) {
    return _translations[language]?[key] ?? key;
  }
}
