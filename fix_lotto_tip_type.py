with open('lib/components/lotto_tip_screen.dart', 'r') as f:
    content = f.read()

# Korrigiere den allNumbers Typ-Fehler
old_line = "    final allNumbers = [\n      ..._currentTip['mainNumbers'] ?? [],\n      ..._currentTip['bonusNumbers'] ?? []\n    ];"
new_line = "    final List<int> allNumbers = [\n      ...?_currentTip['mainNumbers'] ?? [],\n      ...?_currentTip['bonusNumbers'] ?? []\n    ];"

content = content.replace(old_line, new_line)

with open('lib/components/lotto_tip_screen.dart', 'w') as f:
    f.write(content)

print("✅ Lotto Tip Screen Typ-Fehler korrigiert")
