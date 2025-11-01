with open('lib/services/lotto_system_service.dart', 'r') as f:
    content = f.read()

# Korrigiere die kaputte Schedule-Zeile
content = content.replace(
    "      schedule: 'Dienstags schedule: 'Dienstags schedule: 'Mittwochs & Freitags' Freitags', Freitags',",
    "      schedule: 'Dienstags & Freitags',"
)

with open('lib/services/lotto_system_service.dart', 'w') as f:
    f.write(content)

print("✅ Eurojackpot Schedule korrigiert")
