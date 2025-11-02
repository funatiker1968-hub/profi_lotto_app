import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class DisclaimerService {
  static const String _disclaimerKey = 'disclaimer_accepted';

  Future<bool> isDisclaimerAccepted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_disclaimerKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> setDisclaimerAccepted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_disclaimerKey, true);
    } catch (e) {
      debugPrint('Fehler beim Speichern des Disclaimer: $e');
    }
  }

  Future<void> resetDisclaimer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_disclaimerKey);
    } catch (e) {
      debugPrint('Fehler beim Zurücksetzen des Disclaimer: $e');
    }
  }

  // Verbesserte Disclaimer-Texte
  static Map<String, String> getDisclaimerTexts(String languageCode) {
    switch (languageCode) {
      case 'de':
        return _germanDisclaimer;
      case 'en':
        return _englishDisclaimer;
      case 'tr':
        return _turkishDisclaimer;
      default:
        return _germanDisclaimer;
    }
  }

  static final Map<String, String> _germanDisclaimer = {
    'title': 'Wichtiger Haftungsausschluss',
    'content': '''
**EXPERIMENTELLES PROGRAMM - KEINE GEWINNGARANTIE**

Diese Anwendung ist ein rein experimentelles Projekt ohne jeglichen Anspruch auf:
• Richtigkeit der generierten Zahlen
• Mathematische Gewinnoptimierung  
• Garantie auf Gewinne oder Erfolge

**HAFTUNGSAUSSCHLUSS DES INITIATORS:**
Der Entwickler und Initiator dieser App übernimmt ausdrücklich KEINE Haftung für:
• Finanzielle Verluste durch Spieleinsätze
• Falsche Erwartungen an Gewinnchancen
• Entscheidungen basierend auf den generierten Zahlen
• Technische Fehler oder Ungenauigkeiten

**WICHTIGE HINWEISE:**
• Die generierten Zahlen sind ZUFALLSERGEBNISSE
• Keine Verbindung zu offiziellen Lotteriegesellschaften
• Spielen verursacht Kosten - setzen Sie nur Geld ein, das Sie verlieren können
• Statistiken und Analysen dienen nur Unterhaltungszwecken

**ALTERSBESCHRÄNKUNG & VERANTWORTUNG:**
Nur für volljährige Personen (18+). Glücksspiel kann süchtig machen.

Durch Akzeptieren bestätigen Sie, diesen Haftungsausschluss vollständig verstanden zu haben.
''',
    'accept': 'Ich verstehe und akzeptiere vollständig',
    'decline': 'Ablehnen und App schließen',
    'continue': 'Fortfahren',
  };

  static final Map<String, String> _englishDisclaimer = {
    'title': 'Important Disclaimer',
    'content': '''
**EXPERIMENTAL PROGRAM - NO WIN GUARANTEE**

This application is a purely experimental project without any claim to:
• Accuracy of generated numbers
• Mathematical win optimization
• Guarantee of winnings or success

**INITIATOR LIABILITY DISCLAIMER:**
The developer and initiator of this app expressly assumes NO liability for:
• Financial losses through game stakes
• False expectations about winning chances  
• Decisions based on the generated numbers
• Technical errors or inaccuracies

**IMPORTANT NOTES:**
• The generated numbers are RANDOM RESULTS
• No connection to official lottery companies
• Playing incurs costs - only stake money you can afford to lose
• Statistics and analyses are for entertainment purposes only

**AGE RESTRICTION & RESPONSIBILITY:**
For adults only (18+). Gambling can be addictive.

By accepting, you confirm that you have fully understood this disclaimer.
''',
    'accept': 'I fully understand and accept',
    'decline': 'Decline and close app',
    'continue': 'Continue',
  };

  static final Map<String, String> _turkishDisclaimer = {
    'title': 'Önemli Sorumluluk Reddi',
    'content': '''
**DENEYSEL PROGRAM - KAZANMA GARANTİSİ YOKTUR**

Bu uygulama aşağıdakiler konusunda hiçbir iddiası olmayan tamamen deneysel bir projedir:
• Üretilen numaraların doğruluğu
• Matematiksel kazanç optimizasyonu
• Kazanç veya başarı garantisi

**BAŞLATICI SORUMLULUK REDDİ:**
Bu uygulamanın geliştiricisi ve başlatıcısı aşağıdakiler için açıkça SORUMLULUK KABUL ETMEZ:
• Oyun bahisleri yoluyla oluşan mali kayıplar
• Kazanma şansları hakkındaki yanlış beklentiler
• Üretilen numaralara dayalı kararlar
• Teknik hatalar veya yanlışlıklar

**ÖNEMLİ NOTLAR:**
• Üretilen numaralar RASTGELE SONUÇLARDIR
• Resmi piyango şirketleriyle bağlantı yoktur
• Oynamak maliyete neden olur - yalnızca kaybetmeyi göze alabileceğiniz parayı kullanın
• İstatistikler ve analizler yalnızca eğlence amaçlıdır

**YAŞ SINIRLAMASI & SORUMLULUK:**
Yalnızca yetişkinler (18+) içindir. Kumar bağımlılık yapabilir.

Kabul ederek, bu sorumluluk reddini tamamen anladığınızı onaylarsınız.
''',
    'accept': 'Tamamen anladım ve kabul ediyorum',
    'decline': 'Reddet ve uygulamayı kapat',
    'continue': 'Devam et',
  };
}
