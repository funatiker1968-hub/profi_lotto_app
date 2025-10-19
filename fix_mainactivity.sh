#!/bin/bash
# ============================================
# Schritt 2 (automatisch): MainActivity.kt bereinigen, neu erstellen & prüfen
# ============================================

set -e  # Script bricht bei Fehlern ab

echo "📍 Starte Bereinigung und Neuerstellung der MainActivity.kt ..."

# 1️⃣ Projektpfad festlegen
PROJECT_DIR=~/lottoapp_project
APP_DIR="$PROJECT_DIR/android/app/src/main/kotlin/com/example/lottoapp_project"

# 2️⃣ Wechsel in Projektordner
cd "$PROJECT_DIR" || { echo "❌ Projektordner nicht gefunden!"; exit 1; }

# 3️⃣ Alte Dateien löschen
echo "🧹 Suche und lösche alte MainActivity.kt-Dateien..."
find android/app/src/main/kotlin -name "MainActivity.kt" -delete || true

# 4️⃣ Zielordner sicherstellen
echo "📂 Stelle sicher, dass Ordner existiert: $APP_DIR"
mkdir -p "$APP_DIR"

# 5️⃣ Neue Datei erstellen
echo "📝 Erstelle neue MainActivity.kt..."
cat << 'EOF' > "$APP_DIR/MainActivity.kt"
package com.example.lottoapp_project

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
}
EOF

# 6️⃣ Kontrolle: Datei anzeigen
echo "🔍 Prüfe neue Datei:"
echo "---------------------------------"
cat "$APP_DIR/MainActivity.kt"
echo "---------------------------------"

# 7️⃣ Sicherheitsprüfung, ob Import korrekt ist
if grep -q "io.flutter.embedding.android.FlutterActivity" "$APP_DIR/MainActivity.kt"; then
    echo "✅ MainActivity.kt wurde korrekt erstellt!"
else
    echo "❌ Fehler: FlutterActivity Import fehlt!"
    exit 1
fi

# 8️⃣ Test-Build vorbereiten
echo "🚀 Starte Test-Build (Debug)..."
flutter clean
flutter pub get

# 9️⃣ Build starten
flutter build apk --debug

# 🔟 Erfolg prüfen
APK_PATH="$PROJECT_DIR/build/app/outputs/flutter-apk/app-debug.apk"
if [ -f "$APK_PATH" ]; then
    echo "🎉 Erfolg! Debug-APK wurde erstellt unter:"
    echo "   $APK_PATH"
else
    echo "❌ Build fehlgeschlagen! Bitte Ausgabe oben prüfen."
fi
