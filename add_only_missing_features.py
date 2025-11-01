import re

with open('lib/components/jackpot_overview_screen.dart', 'r') as f:
    content = f.read()

# 1. Füge fehlende Imports hinzu
if 'theme_service.dart' not in content:
    # Füge nach language_service.dart ein
    content = content.replace(
        "import '../services/language_service.dart';",
        "import '../services/language_service.dart';\nimport '../services/theme_service.dart';\nimport 'stats_screen.dart';"
    )

# 2. Füge ThemeService Initialisierung hinzu
if 'ThemeService _themeService' not in content:
    # Füge nach LanguageService ein
    content = content.replace(
        "final LanguageService _languageService = LanguageService();",
        "final LanguageService _languageService = LanguageService();\n  final ThemeService _themeService = ThemeService();"
    )

# 3. Füge fehlende Funktionen hinzu (einfache Version)
if '_switchLanguage' not in content:
    # Füge nach _handleBackToOverview ein
    insert_point = content.find('_handleBackToOverview')
    if insert_point != -1:
        func_end = content.find('}', insert_point)
        if func_end != -1:
            new_functions = '''
  
  void _switchLanguage() {
    _languageService.switchLanguage();
    setState(() {});
  }

  void _switchTheme() {
    _themeService.switchTheme();
    setState(() {});
  }

  void _navigateToStats() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StatsScreen()),
    );
  }'''
            content = content[:func_end + 1] + new_functions + content[func_end + 1:]

# 4. Füge Action-Buttons zur AppBar hinzu (einfache Version)
if 'actions: [' not in content:
    # Finde AppBar und füge actions hinzu
    appbar_start = content.find('appBar: AppBar(')
    if appbar_start != -1:
        appbar_end = content.find('),', appbar_start) + 2
        appbar_content = content[appbar_start:appbar_end]
        
        # Füge actions vor der schließenden Klammer ein
        new_appbar = appbar_content[:-2] + ''',
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _switchLanguage,
            tooltip: "Sprache wechseln",
          ),
          IconButton(
            icon: Icon(_themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _switchTheme,
            tooltip: "Theme wechseln",
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: _navigateToStats,
            tooltip: "Statistik anzeigen",
          ),
        ],''' + appbar_content[-2:]
        
        content = content[:appbar_start] + new_appbar + content[appbar_end:]

with open('lib/components/jackpot_overview_screen.dart', 'w') as f:
    f.write(content)

print("✅ Nur die notwendigen Features hinzugefügt")
print("✅ Sprachwechsel, Theme-Switch und Statistik-Buttons integriert")
