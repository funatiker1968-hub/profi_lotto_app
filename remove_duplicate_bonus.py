with open('lib/components/lotto_tip_screen.dart', 'r') as f:
    content = f.read()

# Entferne die überflüssige separate Bonus-Zahlen Anzeige
old_bonus_section = '''                // Bonus Zahlen
                if (_currentBonusNumbers.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Bonus:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: _currentBonusNumbers.map((number) => _buildNumberChip(number, isBonus: true)).toList(),
                  ),
                ],'''

new_bonus_section = '''                // Bonus Zahlen werden jetzt zusammen mit Hauptzahlen angezeigt'''

content = content.replace(old_bonus_section, new_bonus_section)

with open('lib/components/lotto_tip_screen.dart', 'w') as f:
    f.write(content)

print("✅ Überflüssige Bonus-Zahlen Anzeige entfernt")
