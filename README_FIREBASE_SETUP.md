# Smart Lotto Generator (Profi Version)

**Initiator:** Yalcin Kaya

Diese Version ist Codemagic-fertig, unterstützt Deutsch 🇩🇪 & Türkisch 🇹🇷,
und enthält vorbereitete, aber deaktivierte Firebase-Funktionen.

## 🚀 Hauptfunktionen
- Lotto 6 aus 49 mit Zufallszahlen & Häufigkeitsanalyse
- Eigene Tippzahlen speichern & analysieren
- Kosten- & Gewinnübersicht
- Cloud-Sync (Firebase optional)
- Light & Dark Mode
- Offline-Support (lokal gespeichert)

## 🧰 Installation
1. Lade dieses Projekt als ZIP bei [https://codemagic.io](https://codemagic.io) hoch
2. Wähle "Flutter" als Projektart
3. Aktiviere nur "Android"
4. Build Mode: Release
5. Starte den Build

Nach dem Build findest du unter **Artifacts → app-release.apk** deine App.

## 🔥 Firebase Setup (optional)
Die App enthält vorbereiteten Code für Firebase Cloud Sync.
Standardmäßig ist er deaktiviert, damit die App sofort buildbar ist.

Wenn du Cloud Sync aktivieren willst:
1. Gehe zu [https://firebase.google.com](https://firebase.google.com)
2. Erstelle ein neues Projekt (z. B. SmartLottoCloud)
3. Füge eine Android-App hinzu
   - Package name: `com.smartlotto.profi`
   - Lade `google-services.json` herunter
4. Kopiere die Datei nach: `android/app/google-services.json`
5. In lib/main.dart entferne die Kommentarzeichen bei:
   ```dart
   // import 'package:firebase_core/firebase_core.dart';
   // await Firebase.initializeApp();
   ```
6. Führe `flutter pub get` und dann `flutter build apk` aus

Fertig ✅

---
© 2025 Yalcin Kaya — Smart Lotto Generator Profi Cloud Ready
