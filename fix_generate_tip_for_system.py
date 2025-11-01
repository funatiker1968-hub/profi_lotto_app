with open('lib/services/lotto_service.dart', 'r') as f:
    content = f.read()

# Korrigiere generateTipForSystem um Map zurückzugeben
old_method = '''List<int> generateTipForSystem(LottoSystem system) {
    final mainNumbers = _generateNumbers(system.mainNumbersCount, system.mainNumbersMax);

    if (system.hasBonusNumbers) {
      final bonusNumbers = _generateNumbers(system.bonusNumbersCount, system.bonusNumbersMax);
      return [...mainNumbers, ...bonusNumbers];
    }
    return mainNumbers;
  }'''

new_method = '''Map<String, List<int>> generateTipForSystem(LottoSystem system) {
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

print("✅ generateTipForSystem korrigiert - gibt jetzt Map zurück")
