import re

# Lese das Original-Backup
with open('lib/components/jackpot_overview_screen.dart.backup_pre_major_fix', 'r') as f:
    original = f.read()

# Füge die fehlenden Imports hinzu
imports = '''import 'package:flutter/material.dart';
import '../services/lotto_system_service.dart';
import '../services/jackpot_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import 'lotto_tip_screen.dart';
import 'stats_screen.dart';
'''

# Finde die Klasse und füge ThemeService hinzu
class_start = original.find('class _JackpotOverviewScreenState')
if class_start != -1:
    # Füge ThemeService nach LanguageService ein
    theme_service_pos = original.find('LanguageService _languageService')
    if theme_service_pos != -1:
        line_end = original.find(';', theme_service_pos) + 1
        original = original[:line_end] + '\n  final ThemeService _themeService = ThemeService();' + original[line_end:]

# Füge die fehlenden Funktionen nach _handleBackToOverview hinzu
back_to_overview_pos = original.find('_handleBackToOverview')
if back_to_overview_pos != -1:
    func_end = original.find('}', back_to_overview_pos)
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
        original = original[:func_end + 1] + new_functions + original[func_end + 1:]

# Füge actions zur AppBar hinzu (korrekt formatiert)
appbar_pattern = r'(appBar: AppBar\(\s*title: [^,]+,)(\s*backgroundColor: [^,]+,)(\s*foregroundColor: [^,]+,)(\s*\),)'
replacement = r'\1\2\3\n        actions: [\n          IconButton(\n            icon: const Icon(Icons.language),\n            onPressed: _switchLanguage,\n            tooltip: "Sprache wechseln",\n          ),\n          IconButton(\n            icon: Icon(_themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),\n            onPressed: _switchTheme,\n            tooltip: "Theme wechseln",\n          ),\n          IconButton(\n            icon: const Icon(Icons.analytics),\n            onPressed: _navigateToStats,\n            tooltip: "Statistik anzeigen",\n          ),\n        ],\4'

original = re.sub(appbar_pattern, replacement, original)

# Schreibe die korrigierte Version
with open('lib/components/jackpot_overview_screen.dart', 'w') as f:
    f.write(original)

print("✅ Korrekte Version mit allen Features erstellt")
