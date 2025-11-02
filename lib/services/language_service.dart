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
      'statistics': 'Statistik & Analyse',
      'lottoSystem': 'Lotto System',
      'analysisPeriod': 'Analyse-Zeitraum',
      'timePeriod': 'Zeitraum',
      'period': 'Periode',
      'analysis': 'Auswertung',
      'drawsAnalyzed': 'Ziehungen analysiert',
      'statisticsOverview': 'Statistik Übersicht',
      'analyzedDraws': 'Analysierte Ziehungen',
      'averageFrequency': 'Durchschnittliche Häufigkeit',
      'years': 'Jahre',
      'basedOnHistorical': 'Basierend auf historischen Daten von',
      'until': 'bis',
      'hotNumbers': 'Heiße Zahlen',
      'mostFrequentlyDrawn': 'Am häufigsten gezogen',
      'basedOn': 'basierend auf',
      'draws': 'Ziehungen',
      'hotNumbersDescription': 'Diese Zahlen wurden im analysierten Zeitraum am häufigsten gezogen',
      'coldNumbers': 'Kalte Zahlen',
      'leastFrequentlyDrawn': 'Am seltensten gezogen',
      'coldNumbersDescription': 'Diese Zahlen wurden im analysierten Zeitraum am seltensten gezogen',
      'currentTrends': 'Aktuelle Trends',
      'trendAnalysis': 'Trendanalyse',
      'rising': 'Aufsteigend',
      'falling': 'Absteigend',
      'noSignificantTrends': 'Keine signifikanten Trends in den letzten Jahren festgestellt',
      'statisticsDisclaimer': 'Diese Statistik basiert auf historischen Ziehungsdaten der letzten 10 Jahre. Vergangene Ergebnisse sind kein Indikator für zukünftige Gewinne.',
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
      'statistics': 'Statistics & Analysis',
      'lottoSystem': 'Lotto System',
      'analysisPeriod': 'Analysis Period',
      'timePeriod': 'Time Period',
      'period': 'Period',
      'analysis': 'Analysis',
      'drawsAnalyzed': 'draws analyzed',
      'statisticsOverview': 'Statistics Overview',
      'analyzedDraws': 'Analyzed Draws',
      'averageFrequency': 'Average Frequency',
      'years': 'Years',
      'basedOnHistorical': 'Based on historical data from',
      'until': 'until',
      'hotNumbers': 'Hot Numbers',
      'mostFrequentlyDrawn': 'Most frequently drawn',
      'basedOn': 'based on',
      'draws': 'draws',
      'hotNumbersDescription': 'These numbers were drawn most frequently in the analyzed period',
      'coldNumbers': 'Cold Numbers',
      'leastFrequentlyDrawn': 'Least frequently drawn',
      'coldNumbersDescription': 'These numbers were drawn least frequently in the analyzed period',
      'currentTrends': 'Current Trends',
      'trendAnalysis': 'Trend Analysis',
      'rising': 'Rising',
      'falling': 'Falling',
      'noSignificantTrends': 'No significant trends detected in recent years',
      'statisticsDisclaimer': 'This statistics is based on historical draw data from the last 10 years. Past results are no indicator for future winnings.',
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
      'statistics': 'İstatistik & Analiz',
      'lottoSystem': 'Lotto Sistemi',
      'analysisPeriod': 'Analiz Dönemi',
      'timePeriod': 'Zaman Aralığı',
      'period': 'Dönem',
      'analysis': 'Analiz',
      'drawsAnalyzed': 'çekiliş analiz edildi',
      'statisticsOverview': 'İstatistik Özeti',
      'analyzedDraws': 'Analiz Edilen Çekilişler',
      'averageFrequency': 'Ortalama Sıklık',
      'years': 'Yıl',
      'basedOnHistorical': 'Tarihsel verilere dayanarak',
      'until': 'kadar',
      'hotNumbers': 'Sıcak Numaralar',
      'mostFrequentlyDrawn': 'En sık çekilen',
      'basedOn': 'dayanarak',
      'draws': 'çekiliş',
      'hotNumbersDescription': 'Bu numaralar analiz edilen dönemde en sık çekildi',
      'coldNumbers': 'Soğuk Numaralar',
      'leastFrequentlyDrawn': 'En az çekilen',
      'coldNumbersDescription': 'Bu numaralar analiz edilen dönemde en az çekildi',
      'currentTrends': 'Güncel Trendler',
      'trendAnalysis': 'Trend Analizi',
      'rising': 'Yükselen',
      'falling': 'Düşen',
      'noSignificantTrends': 'Son yıllarda önemli bir trend tespit edilmedi',
      'statisticsDisclaimer': 'Bu istatistikler son 10 yılın tarihsel çekiliş verilerine dayanmaktadır. Geçmiş sonuçlar gelecek kazançlar için gösterge değildir.',
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
