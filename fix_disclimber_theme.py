with open('lib/components/disclimber_wrapper.dart', 'r') as f:
    content = f.read()

# Korrigiere die Theme-Zeile
content = content.replace(
    "      theme: _themeService.currentTheme,", 
    "      theme: _themeService.isDarkMode ? ThemeData.dark() : ThemeData.light(),"
)

with open('lib/components/disclimber_wrapper.dart', 'w') as f:
    f.write(content)

print("✅ Theme Service Fehler korrigiert")
