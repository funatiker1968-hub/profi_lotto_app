import '../models/lotto_system.dart';

class LottoService {
  List<int> generateTip() {
    return _generateNumbers(6, 49);
  }

  List<int> generateTipForSystem(LottoSystem system) {
    final mainNumbers = _generateNumbers(system.mainNumbersCount, system.mainNumbersMax);
    
    if (system.hasExtraNumbers) {
      final extraNumbers = _generateNumbers(system.extraNumbersCount, system.extraNumbersMax);
      return [...mainNumbers, ...extraNumbers];
    }
    
    return mainNumbers;
  }

  List<int> _generateNumbers(int count, int max) {
    final numbers = <int>[];
    final random = DateTime.now().microsecondsSinceEpoch;
    
    while (numbers.length < count) {
      final number = (random % max) + 1;
      if (!numbers.contains(number)) {
        numbers.add(number);
      }
    }
    
    numbers.sort();
    return numbers;
  }

  Map<String, dynamic> analyzeTips(List<List<int>> tips) {
    final frequency = <int, int>{};
    
    for (final tip in tips) {
      for (final number in tip) {
        frequency[number] = (frequency[number] ?? 0) + 1;
      }
    }
    
    final sortedNumbers = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final hotNumbers = sortedNumbers.take(6).map((e) => e.key).toList();
    final coldNumbers = sortedNumbers.reversed.take(6).map((e) => e.key).toList();
    
    return {
      'hotNumbers': hotNumbers,
      'coldNumbers': coldNumbers,
      'totalTips': tips.length,
    };
  }
}
