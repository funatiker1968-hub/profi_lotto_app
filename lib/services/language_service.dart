class LanguageService {
  final Map<String, Map<String, String>> _translations = {
    'de': {
      'appTitle': 'Lotto World Pro',
      'welcome': 'Willkommen',
      'selectLottery': 'Lotto-System auswählen',
      'selectLotteryDesc': 'Wähle eines der verfügbaren Lotto-Systeme aus',
      'continueWith': 'Weiter mit',
      'yourTip': 'Dein Tipp',
      'newTip': 'Neuer Tipp',
      'saveTip': 'Tipp speichern',
      'savedTips': 'Gespeicherte Tipps',
      'noSavedTips': 'Noch keine Tipps gespeichert',
      'extraNumbers': 'Zusatzzahlen',
      'systemRules': 'Systemregeln',
      'lotto6aus49': 'Lotto 6aus49',
      'eurojackpot': 'Eurojackpot',
      'sayisalLoto': 'Sayısal Loto',
      'sansTopu': 'Şans Topu',
      'disclaimerTitle': 'Haftungsausschluss',
      'disclaimerText': 'Diese App dient nur zu Unterhaltungszwecken. Glücksspiel kann süchtig machen.',
      'accept': 'Akzeptieren',
      'decline': 'Ablehnen',
    },
    'en': {
      'appTitle': 'Lotto World Pro',
      'welcome': 'Welcome',
      'selectLottery': 'Select Lottery System',
      'selectLotteryDesc': 'Choose one of the available lottery systems',
      'continueWith': 'Continue with',
      'yourTip': 'Your Tip',
      'newTip': 'New Tip',
      'saveTip': 'Save Tip',
      'savedTips': 'Saved Tips',
      'noSavedTips': 'No tips saved yet',
      'extraNumbers': 'Extra Numbers',
      'systemRules': 'System Rules',
      'lotto6aus49': 'Lotto 6aus49',
      'eurojackpot': 'Eurojackpot',
      'sayisalLoto': 'Sayısal Loto',
      'sansTopu': 'Şans Topu',
      'disclaimerTitle': 'Disclaimer',
      'disclaimerText': 'This app is for entertainment purposes only. Gambling can be addictive.',
      'accept': 'Accept',
      'decline': 'Decline',
    },
    'tr': {
      'appTitle': 'Lotto World Pro',
      'welcome': 'Hoş Geldiniz',
      'selectLottery': 'Loto Sistemi Seçin',
      'selectLotteryDesc': 'Mevcut loto sistemlerinden birini seçin',
      'continueWith': 'İle devam et',
      'yourTip': 'Tahmininiz',
      'newTip': 'Yeni Tahmin',
      'saveTip': 'Tahmini Kaydet',
      'savedTips': 'Kayıtlı Tahminler',
      'noSavedTips': 'Henüz tahmin kaydedilmedi',
      'extraNumbers': 'Ekstra Sayılar',
      'systemRules': 'Sistem Kuralları',
      'lotto6aus49': 'Lotto 6aus49',
      'eurojackpot': 'Eurojackpot',
      'sayisalLoto': 'Sayısal Loto',
      'sansTopu': 'Şans Topu',
      'disclaimerTitle': 'Feragatname',
      'disclaimerText': 'Bu uygulama sadece eğlence amaçlıdır. Kumar bağımlılık yapabilir.',
      'accept': 'Kabul Et',
      'decline': 'Reddet',
    },
  };

  String _currentLanguage = 'de';

  String getTranslation(String key) {
    return _translations[_currentLanguage]?[key] ?? key;
  }

  void setLanguage(String languageCode) {
    if (_translations.containsKey(languageCode)) {
      _currentLanguage = languageCode;
    }
  }

  String get currentLanguage => _currentLanguage;

  // NEUE METHODE: Sprachwechsel durchzyklieren
  void switchLanguage() {
    final languages = ['de', 'en', 'tr'];
    final currentIndex = languages.indexOf(_currentLanguage);
    final nextIndex = (currentIndex + 1) % languages.length;
    _currentLanguage = languages[nextIndex];
  }

  List<String> get availableLanguages => ['de', 'en', 'tr'];
  
  String getCurrentLanguageName() {
    switch (_currentLanguage) {
      case 'de': return 'Deutsch';
      case 'en': return 'English';
      case 'tr': return 'Türkçe';
      default: return 'Deutsch';
    }
  }
}
