with open('lib/components/lotto_tip_screen.dart', 'r') as f:
    lines = f.readlines()

# Korrigiere Zeilen 49-52
lines[49] = '    setState(() {\n'
lines[50] = '      _currentTip = _lottoService.generateTipForSystem(widget.selectedSystem) as Map<String, List<int>>;\n'
lines[51] = '    });\n'

# Entferne überflüssige Zeilen
new_lines = lines[:52]  # Behalte nur bis Zeile 52

with open('lib/components/lotto_tip_screen.dart', 'w') as f:
    f.writelines(new_lines)

print("✅ Beschädigte Zeilen korrigiert")
