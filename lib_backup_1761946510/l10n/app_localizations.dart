import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // Sprachspezifische Texte
  String get appTitle => _getLocalizedText('appTitle', 'LOTTO WORLD PRO');
  String get yourWinningNumbers => _getLocalizedText('yourWinningNumbers', 'YOUR WINNING NUMBERS');
  String get pressSpinToStart => _getLocalizedText('pressSpinToStart', 'Press SPIN to start');
  String get spin => _getLocalizedText('spin', 'SPIN');
  String get save => _getLocalizedText('save', 'SAVE');
  String get tips => _getLocalizedText('tips', 'TIPS');
  String get cost => _getLocalizedText('cost', 'COST');
  String get quickTips => _getLocalizedText('quickTips', 'QUICK TIPS');
  String get megaTips => _getLocalizedText('megaTips', 'MEGA TIPS');
  String get myWinningTips => _getLocalizedText('myWinningTips', 'MY WINNING TIPS');
  String get noTipsYet => _getLocalizedText('noTipsYet', 'No tips yet');
  String get generateLuckyNumbers => _getLocalizedText('generateLuckyNumbers', 'Generate your lucky numbers!');
  String get statistics => _getLocalizedText('statistics', 'STATISTICS');
  String get tipAnalysis => _getLocalizedText('tipAnalysis', 'TIP ANALYSIS');
  String get winSimulation => _getLocalizedText('winSimulation', 'WIN SIMULATION');
  String get overview => _getLocalizedText('overview', 'OVERVIEW');
  String get totalTips => _getLocalizedText('totalTips', 'Total tips');
  String get usedNumbers => _getLocalizedText('usedNumbers', 'Used numbers');
  String get averageFrequency => _getLocalizedText('averageFrequency', 'Average frequency');
  String get hotNumbers => _getLocalizedText('hotNumbers', 'HOT NUMBERS');
  String get coldNumbers => _getLocalizedText('coldNumbers', 'COLD NUMBERS');
  String get fullFrequency => _getLocalizedText('fullFrequency', 'FULL FREQUENCY');
  String get selectTip => _getLocalizedText('selectTip', 'SELECT TIP');
  String get currentTip => _getLocalizedText('currentTip', 'CURRENT TIP');
  String get patternAnalysis => _getLocalizedText('patternAnalysis', 'PATTERN ANALYSIS');
  String get consecutiveNumbers => _getLocalizedText('consecutiveNumbers', 'Consecutive numbers');
  String get lowHighRatio => _getLocalizedText('lowHighRatio', 'Low/High ratio');
  String get evenOddRatio => _getLocalizedText('evenOddRatio', 'Even/Odd ratio');
  String get averageGap => _getLocalizedText('averageGap', 'Average gap');
  String get maxGap => _getLocalizedText('maxGap', 'Max gap');
  String get qualityRating => _getLocalizedText('qualityRating', 'QUALITY RATING');
  String get improvementSuggestions => _getLocalizedText('improvementSuggestions', 'IMPROVEMENT SUGGESTIONS');
  String get yes => _getLocalizedText('yes', 'Yes');
  String get no => _getLocalizedText('no', 'No');
  String get light => _getLocalizedText('light', 'Light');
  String get dark => _getLocalizedText('dark', 'Dark');
  String get system => _getLocalizedText('system', 'System');
  String get tipSaved => _getLocalizedText('tipSaved', 'Tip saved!');
  String get allTipsDeleted => _getLocalizedText('allTipsDeleted', 'All tips deleted!');
  String get tipsGenerated => _getLocalizedText('tipsGenerated', 'Tips generated!');
  String get createTipsFirst => _getLocalizedText('createTipsFirst', 'Create some tips first!');

  String _getLocalizedText(String key, String fallback) {
    // Einfache Sprach-Logik - später mit ARB erweitern
    switch (locale.languageCode) {
      case 'de':
        return _getGermanText(key, fallback);
      case 'tr':
        return _getTurkishText(key, fallback);
      case 'en':
      default:
        return fallback;
    }
  }

  String _getGermanText(String key, String fallback) {
    switch (key) {
      case 'appTitle': return 'LOTTO WORLD PRO';
      case 'yourWinningNumbers': return 'DEINE GEWINNZAHLEN';
      case 'pressSpinToStart': return 'Drücke SPIN um zu starten';
      case 'spin': return 'SPIN';
      case 'save': return 'SPEICHERN';
      case 'tips': return 'TIPPS';
      case 'cost': return 'EINSATZ';
      case 'quickTips': return 'QUICK TIPPS';
      case 'megaTips': return 'MEGA TIPPS';
      case 'myWinningTips': return 'MEINE GEWINNTIPPS';
      case 'noTipsYet': return 'Noch keine Tipps';
      case 'generateLuckyNumbers': return 'Generiere deine Glückszahlen!';
      case 'statistics': return 'STATISTIK';
      case 'tipAnalysis': return 'TIPP ANALYSE';
      case 'winSimulation': return 'GEWINN-SIMULATION';
      case 'overview': return 'ÜBERSICHT';
      case 'totalTips': return 'Gesamte Tipps';
      case 'usedNumbers': return 'Verwendete Zahlen';
      case 'averageFrequency': return 'Durchschn. Häufigkeit';
      case 'hotNumbers': return 'HEISSE ZAHLEN';
      case 'coldNumbers': return 'KALTE ZAHLEN';
      case 'fullFrequency': return 'VOLLSTÄNDIGE HÄUFIGKEIT';
      case 'selectTip': return 'TIPP AUSWÄHLEN';
      case 'currentTip': return 'AKTUELLER TIPP';
      case 'patternAnalysis': return 'MUSTER-ANALYSE';
      case 'consecutiveNumbers': return 'Aufeinanderfolgende Zahlen';
      case 'lowHighRatio': return 'Tiefe/Zahlen Verhältnis';
      case 'evenOddRatio': return 'Gerade/Ungerade Verhältnis';
      case 'averageGap': return 'Durchschn. Zahlenabstand';
      case 'maxGap': return 'Max. Zahlenabstand';
      case 'qualityRating': return 'QUALITÄTSBEWERTUNG';
      case 'improvementSuggestions': return 'VERBESSERUNGSVORSCHLÄGE';
      case 'yes': return 'Ja';
      case 'no': return 'Nein';
      case 'light': return 'Hell';
      case 'dark': return 'Dunkel';
      case 'system': return 'System';
      case 'tipSaved': return 'Tipp gespeichert!';
      case 'allTipsDeleted': return 'Alle Tipps gelöscht!';
      case 'tipsGenerated': return 'Tipps generiert!';
      case 'createTipsFirst': return 'Erstelle zuerst einige Tipps!';
      default: return fallback;
    }
  }

  String _getTurkishText(String key, String fallback) {
    switch (key) {
      case 'appTitle': return 'LOTTO WORLD PRO';
      case 'yourWinningNumbers': return 'KAZANAN NUMARALARIN';
      case 'pressSpinToStart': return 'Başlamak için SPIN e bas';
      case 'spin': return 'SPIN';
      case 'save': return 'KAYDET';
      case 'tips': return 'TAVSİYELER';
      case 'cost': return 'MASRAF';
      case 'quickTips': return 'HIZLI TAVSİYELER';
      case 'megaTips': return 'MEGA TAVSİYELER';
      case 'myWinningTips': return 'KAZANAN TAVSİYELERİM';
      case 'noTipsYet': return 'Henüz tavsiye yok';
      case 'generateLuckyNumbers': return 'Şanslı numaralarını oluştur!';
      case 'statistics': return 'İSTATİSTİKLER';
      case 'tipAnalysis': return 'TAVSİYE ANALİZİ';
      case 'winSimulation': return 'KAZANÇ SİMÜLASYONU';
      case 'overview': return 'GENEL BAKIŞ';
      case 'totalTips': return 'Toplam tavsiye';
      case 'usedNumbers': return 'Kullanılan numaralar';
      case 'averageFrequency': return 'Ort. frekans';
      case 'hotNumbers': return 'SICAK NUMARALAR';
      case 'coldNumbers': return 'SOĞUK NUMARALAR';
      case 'fullFrequency': return 'TAM FREKANS';
      case 'selectTip': return 'TAVSİYE SEÇ';
      case 'currentTip': return 'MEVCUT TAVSİYE';
      case 'patternAnalysis': return 'DESEN ANALİZİ';
      case 'consecutiveNumbers': return 'Ardışık numaralar';
      case 'lowHighRatio': return 'Düşük/Yüksek oran';
      case 'evenOddRatio': return 'Çift/Tek oran';
      case 'averageGap': return 'Ort. boşluk';
      case 'maxGap': return 'Maks. boşluk';
      case 'qualityRating': return 'KALİTE DEĞERLENDİRMESİ';
      case 'improvementSuggestions': return 'İYİLEŞTİRME ÖNERİLERİ';
      case 'yes': return 'Evet';
      case 'no': return 'Hayır';
      case 'light': return 'Açık';
      case 'dark': return 'Koyu';
      case 'system': return 'Sistem';
      case 'tipSaved': return 'Tavsiye kaydedildi!';
      case 'allTipsDeleted': return 'Tüm tavsiyeler silindi!';
      case 'tipsGenerated': return 'Tavsiyeler oluşturuldu!';
      case 'createTipsFirst': return 'Önce bazı tavsiyeler oluşturun!';
      default: return fallback;
    }
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['de', 'en', 'tr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
