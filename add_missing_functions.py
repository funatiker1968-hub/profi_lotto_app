with open('lib/components/jackpot_overview_screen.dart', 'r') as f:
    content = f.read()

# Finde die Position nach _handleBackToOverview
insert_point = content.find('_handleBackToOverview')
if insert_point != -1:
    # Finde das Ende dieser Funktion
    func_end = content.find('}', insert_point)
    if func_end != -1:
        # Füge die neuen Funktionen ein
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
        print("✅ Fehlende Funktionen hinzugefügt")
    else:
        print("❌ Funktionsende nicht gefunden")
else:
    print("❌ Einfügepunkt nicht gefunden")

with open('lib/components/jackpot_overview_screen.dart', 'w') as f:
    f.write(content)
