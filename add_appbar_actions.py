with open('lib/components/jackpot_overview_screen.dart', 'r') as f:
    content = f.read()

# Finde die AppBar und füge actions hinzu
import re

# Pattern für die AppBar ohne actions
appbar_pattern = r'(appBar: AppBar\(\s*title: [^,]+,)(\s*backgroundColor: [^,]+,)(\s*foregroundColor: [^,]+,)(\s*\),)'

# Ersetzung mit actions
replacement = r'\1\2\3\n        actions: [\n          IconButton(\n            icon: const Icon(Icons.language),\n            onPressed: _switchLanguage,\n            tooltip: \"Sprache wechseln\",\n          ),\n          IconButton(\n            icon: Icon(_themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),\n            onPressed: _switchTheme,\n            tooltip: \"Theme wechseln\",\n          ),\n          IconButton(\n            icon: const Icon(Icons.analytics),\n            onPressed: _navigateToStats,\n            tooltip: \"Statistik anzeigen\",\n          ),\n        ],\4'

content = re.sub(appbar_pattern, replacement, content)

with open('lib/components/jackpot_overview_screen.dart', 'w') as f:
    f.write(content)

print("✅ Action-Buttons zur AppBar hinzugefügt")
