with open('lib/services/lotto_service.dart', 'r') as f:
    content = f.read()

# Korrigiere die Zahlen-Generierung - Haupt- und Bonus-Zahlen getrennt
old_method = '''static List<int> generateTip(LottoSystem system) {
    final mainNumbers = _generateNumbers(system.mainNumbersCount, system.mainNumbersMax);
    if (system.hasBonusNumbers) {
      final bonusNumbers = _generateNumbers(system.bonusNumbersCount, system.bonusNumbersMax);
      return [...mainNumbers, ...bonusNumbers];
    }
    return mainNumbers;
  }'''

new_method = '''static Map<String, List<int>> generateTip(LottoSystem system) {
    final mainNumbers = _generateNumbers(system.mainNumbersCount, system.mainNumbersMax);
    if (system.hasBonusNumbers) {
      final bonusNumbers = _generateNumbers(system.bonusNumbersCount, system.bonusNumbersMax);
      return {
        'mainNumbers': mainNumbers,
        'bonusNumbers': bonusNumbers,
      };
    }
    return {
      'mainNumbers': mainNumbers,
      'bonusNumbers': [],
    };
  }'''

content = content.replace(old_method, new_method)

with open('lib/services/lotto_service.dart', 'w') as f:
    f.write(content)

print("✅ Zahlen-Generierung repariert - Haupt- und Bonus-Zahlen getrennt")
