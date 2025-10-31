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

  // Disclaimer-Texte
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
    'title': 'Haftungsausschluss & Hinweis',
    'content': '''
**WICHTIGER HAFTUNGSAUSSCHLUSS**

Diese App dient ausschließlich Unterhaltungs- und Experimentierzwecken. 

**Bitte beachten Sie:**

1. **KEINE GEWÄHRLEISTUNG:** 
   - Die generierten Zahlen sind ZUFALLSZAHLEN
   - Es wird KEINE Gewinn-Garantie gegeben
   - Die Zahlen haben KEINE höhere Gewinnwahrscheinlichkeit

2. **EXPERIMENTELLE FUNKTION:**
   - Die App verwendet algorithmische Zufallsgeneratoren
   - Ergebnisse sind statistische Simulationen
   - Keine Verbindung zu offiziellen Lotto-Gesellschaften

3. **RECHTLICHER HINWEIS:**
   - Keine Haftung für finanzielle Verluste
   - Spielen auf eigenes Risiko
   - Verantwortungsvolles Spielen wird empfohlen

4. **ALTERSBESCHRÄNKUNG:**
   - Nur für Personen ab 18 Jahren
   - Glücksspiel kann süchtig machen

Durch die Nutzung dieser App bestätigen Sie, dass Sie diese Bedingungen verstanden und akzeptiert haben.
''',
    'accept': 'Ich verstehe und akzeptiere die Bedingungen',
    'decline': 'Ablehnen und App schließen',
    'continue': 'Fortfahren',
  };

  static final Map<String, String> _englishDisclaimer = {
    'title': 'Disclaimer & Notice',
    'content': '''
**IMPORTANT DISCLAIMER**

This app is for entertainment and experimental purposes only.

**Please note:**

1. **NO WARRANTY:**
   - Generated numbers are RANDOM NUMBERS
   - NO winning guarantee is provided
   - Numbers have NO higher probability of winning

2. **EXPERIMENTAL FEATURE:**
   - The app uses algorithmic random generators
   - Results are statistical simulations
   - No connection to official lottery companies

3. **LEGAL NOTICE:**
   - No liability for financial losses
   - Play at your own risk
   - Responsible gaming is recommended

4. **AGE RESTRICTION:**
   - For persons 18 years and older only
   - Gambling can be addictive

By using this app, you confirm that you have understood and accepted these terms.
''',
    'accept': 'I understand and accept the terms',
    'decline': 'Decline and close app',
    'continue': 'Continue',
  };

  static final Map<String, String> _turkishDisclaimer = {
    'title': 'Sorumluluk Reddi & Uyarı',
    'content': '''
**ÖNEMLİ SORUMLULUK REDDİ**

Bu uygulama yalnızca eğlence ve deneysel amaçlar içindir.

**Lütfen dikkat edin:**

1. **GARANTİ YOKTUR:**
   - Üretilen numaralar RASTGELE SAYILARDIR
   - Kazanma GARANTİSİ verilmez
   - Numara kazanma olasılığı DAHA YÜKSEK DEĞİLDİR

2. **DENEYSEL ÖZELLİK:**
   - Uygulama algoritmik rastgele üreticiler kullanır
   - Sonuçlar istatistiksel simülasyonlardır
   - Resmi piyango şirketleriyle bağlantı yoktur

3. **YASAL UYARI:**
   - Mali kayıplardan sorumluluk kabul edilmez
   - Kendi riskinizle oynayın
   - Sorumlu oyun önerilir

4. **YAŞ SINIRLAMASI:**
   - Sadece 18 yaş ve üstü kişiler içindir
   - Kumar bağımlılık yapabilir

Bu uygulamayı kullanarak, bu şartları anladığınızı ve kabul ettiğinizi onaylarsınız.
''',
    'accept': 'Şartları anladım ve kabul ediyorum',
    'decline': 'Reddet ve uygulamayı kapat',
    'continue': 'Devam et',
  };
}
