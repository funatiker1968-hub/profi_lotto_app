with open('lib/services/storage_service.dart', 'r') as f:
    content = f.read()

# Korrigiere _getAllTips zu getTips
content = content.replace("    final allTips = _getAllTips();", "    final allTips = getTips();")

# Korrigiere _storage zu _prefs
content = content.replace("    await _storage.setStringList(", "    await _prefs.setStringList(")

# Füge jsonEncode Import hinzu
if "import 'dart:convert';" not in content:
    content = "import 'dart:convert';\n" + content

with open('lib/services/storage_service.dart', 'w') as f:
    f.write(content)

print("✅ Storage Service Fehler korrigiert")
