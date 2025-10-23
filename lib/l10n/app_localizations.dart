import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  // Übersetzungen
  String get appTitle => _getText('appTitle', 'LOTTO WORLD PRO');
  String get yourWinningNumbers => _getText('yourWinningNumbers', 'YOUR WINNING NUMBERS');
  String get pressSpinToStart => _getText('pressSpinToStart', 'Press SPIN to start');
  String get spin => _getText('spin', 'SPIN');
  String get save => _getText('save', 'SAVE');
  String get tips => _getText('tips', 'TIPS');
  String get cost => _getText('cost', 'COST');
  String get quickTips => _getText('quickTips', 'QUICK TIPS');
  String get megaTips => _getText('megaTips', 'MEGA TIPS');
  String get myWinningTips => _getText('myWinningTips', 'MY WINNING TIPS');
  String get noTipsYet => _getText('noTipsYet', 'No tips yet');
  String get generateLuckyNumbers => _getText('generateLuckyNumbers', 'Generate your lucky numbers!');
  String get statistics => _getText('statistics', 'STATISTICS');
  String get tipAnalysis => _getText('tipAnalysis', 'TIP ANALYSIS');
  String get winSimulation => _getText('winSimulation', 'WIN SIMULATION');
  String get overview => _getText('overview', 'OVERVIEW');
  String get totalTips => _getText('totalTips', 'Total tips');
  String get usedNumbers => _getText('usedNumbers', 'Used numbers');
  String get averageFrequency => _getText('averageFrequency', 'Average frequency');
  String get hotNumbers => _getText('hotNumbers', 'HOT NUMBERS');
  String get coldNumbers => _getText('coldNumbers', 'COLD NUMBERS');
  String get fullFrequency => _getText('fullFrequency', 'FULL FREQUENCY');
  String get selectTip => _getText('selectTip', 'SELECT TIP');
  String get currentTip => _getText('currentTip', 'CURRENT TIP');
  String get patternAnalysis => _getText('patternAnalysis', 'PATTERN ANALYSIS');
  String get consecutiveNumbers => _getText('consecutiveNumbers', 'Consecutive numbers');
  String get lowHighRatio => _getText('lowHighRatio', 'Low/High ratio');
  String get evenOddRatio => _getText('evenOddRatio', 'Even/Odd ratio');
  String get averageGap => _getText('averageGap', 'Average gap');
  String get maxGap => _getText('maxGap', 'Max gap');
  String get qualityRating => _getText('qualityRating', 'QUALITY RATING');
  String get improvementSuggestions => _getText('improvementSuggestions', 'IMPROVEMENT SUGGESTIONS');
  String get yes => _getText('yes', 'Yes');
  String get no => _getText('no', 'No');
  String get light => _getText('light', 'Light');
  String get dark => _getText('dark', 'Dark');
  String get system => _getText('system', 'System');
  String get tipSaved => _getText('tipSaved', 'Tip saved!');
  String get allTipsDeleted => _getText('allTipsDeleted', 'All tips deleted!');
  String get tipsGenerated => _getText('tipsGenerated', 'Tips generated!');
  String get createTipsFirst => _getText('createTipsFirst', 'Create some tips first!');

  String _getText(String key, String fallback) {
    // Einfache Implementierung - später mit ARB Dateien erweitern
    return fallback;
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
