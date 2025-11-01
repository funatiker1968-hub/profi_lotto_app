with open('lib/services/storage_service.dart', 'r') as f:
    content = f.read()

# Korrigiere den Null-Safety Fehler
content = content.replace(
    "    await _prefs.setStringList('lotto_tips',",
    "    await _prefs?.setStringList('lotto_tips',"
)

with open('lib/services/storage_service.dart', 'w') as f:
    f.write(content)

print("✅ Storage Service Null-Safety Fehler korrigiert")
