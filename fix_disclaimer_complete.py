with open('lib/components/disclimber_wrapper.dart', 'r') as f:
    content = f.read()

# Import für SystemNavigator hinzufügen
if 'package:flutter/services.dart' not in content:
    # Füge Import nach dem ersten Import ein
    first_import_end = content.find(';') + 1
    content = content[:first_import_end] + '\\nimport \\'package:flutter/services.dart\\';' + content[first_import_end:]

# Korrigiere die fehlerhafte Zeile 67
content = content.replace('// App beenden - SystemNavigator benötigt services import', 'SystemNavigator.pop(); // App beenden')

with open('lib/components/disclimber_wrapper.dart', 'w') as f:
    f.write(content)

print("✅ Disclaimer vollständig korrigiert - SystemNavigator importiert und aktiviert")
