import 'dart:math';

class LottoService {
  final Random _random = Random();

  List<int> generateTip() {
    final numbers = <int>[];
    while (numbers.length < 6) {
      final number = _random.nextInt(49) + 1;
      if (!numbers.contains(number)) {
        numbers.add(number);
      }
    }
    numbers.sort();
    return numbers;
  }

  List<int> generateSuperNumber() {
    return [_random.nextInt(10)];
  }

  List<List<int>> generateMultipleTips(int count) {
    return List.generate(count, (index) => generateTip());
  }

  Map<String, dynamic> analyzeTips(List<List<int>> tips) {
    final numberFrequency = <int, int>{};
    for (final tip in tips) {
      for (final number in tip) {
        numberFrequency[number] = (numberFrequency[number] ?? 0) + 1;
      }
    }

    final sortedNumbers = numberFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return {
      'totalTips': tips.length,
      'mostFrequent': sortedNumbers.take(6).map((e) => e.key).toList(),
      'leastFrequent': sortedNumbers.reversed.take(6).map((e) => e.key).toList(),
      'numberFrequency': numberFrequency,
    };
  }
}
