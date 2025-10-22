import 'dart:math';

class LottoService {
  static List<int> generateLottoNumbers() {
    final random = Random();
    final numbers = <int>[];
    
    while (numbers.length < 6) {
      final number = random.nextInt(49) + 1;
      if (!numbers.contains(number)) {
        numbers.add(number);
      }
    }
    
    numbers.sort();
    return numbers;
  }

  static List<List<int>> generateMultipleTips(int count) {
    return List.generate(count, (_) => generateLottoNumbers());
  }

  static int checkWinningClass(List<int> tip, List<int> drawing) {
    final matches = tip.where((number) => drawing.contains(number)).length;
    return matches;
  }

  static double calculateCost(int tips, double pricePerTip) {
    return tips * pricePerTip;
  }
}
