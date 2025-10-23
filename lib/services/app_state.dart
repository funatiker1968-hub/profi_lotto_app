import 'package:flutter/material.dart';
import 'theme_service.dart';
import 'language_service.dart';

class AppState extends ChangeNotifier implements ValueNotifier<bool> {
  final ThemeService _themeService = ThemeService();
  final LanguageService _languageService = LanguageService();
  
  bool _isDarkMode = false;
  String _currentLanguage = 'de';

  @override
  bool get value => _isDarkMode;

  @override
  set value(bool newValue) {
    if (_isDarkMode != newValue) {
      _isDarkMode = newValue;
      _themeService.setDarkMode(newValue);
      notifyListeners();
    }
  }

  bool get isDarkMode => _isDarkMode;
  String get currentLanguage => _currentLanguage;
  LanguageService get languageService => _languageService;

  AppState() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _isDarkMode = await _themeService.isDarkMode();
    _currentLanguage = await _languageService.getCurrentLanguage();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _themeService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> switchLanguage() async {
    if (_currentLanguage == 'de') {
      _currentLanguage = 'en';
    } else if (_currentLanguage == 'en') {
      _currentLanguage = 'tr';
    } else {
      _currentLanguage = 'de';
    }
    await _languageService.setLanguage(_currentLanguage);
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
    return _languageService.translate(key, _currentLanguage);
  }
}
