import 'package:flutter/material.dart';
import 'language_service.dart';

class AppState extends ChangeNotifier {
  bool _isDarkMode = false;
  String _currentLanguage = 'de';
  final LanguageService _languageService = LanguageService();

  bool get isDarkMode => _isDarkMode;
  String get currentLanguage => _currentLanguage;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

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

  void setLanguage(String languageCode) {
    if (['de', 'en', 'tr'].contains(languageCode)) {
      _currentLanguage = languageCode;
      notifyListeners();
    }
  }

  void setDarkMode(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  String getLanguageFlag() {
    switch (_currentLanguage) {
      case 'de': return '🇩🇪';
      case 'en': return '🇺🇸';
      case 'tr': return '🇹🇷';
      default: return '🌐';
    }
  }

  String getLanguageTooltip() {
    switch (_currentLanguage) {
      case 'de': return 'Switch to English';
      case 'en': return 'Türkçe\'ye geç';
      case 'tr': return 'Auf Deutsch wechseln';
      default: return 'Change language';
    }
  }

  String translate(String key) {
    return _languageService.getTranslation(key);
  }
}
