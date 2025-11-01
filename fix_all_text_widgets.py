with open('lib/components/jackpot_overview_screen.dart', 'r') as f:
    content = f.read()

# Finde alle Text-Widgets die keine schließende Klammer haben und korrigiere sie
import re

# Pattern für Text-Widgets ohne schließende Klammer
pattern = r'Text\("[^"]*"\)(?!,)'

# Zähle wie viele gefunden werden
matches = re.findall(pattern, content)
print(f"Gefundene Text-Widgets ohne Klammer: {len(matches)}")

# Korrigiere alle
content = re.sub(pattern, lambda m: m.group(0) + ',', content)

with open('lib/components/jackpot_overview_screen.dart', 'w') as f:
    f.write(content)

print("✅ Alle Text-Widget Klammern korrigiert")
