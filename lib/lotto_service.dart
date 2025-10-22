import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class LottoService {
  // Generiert 6 zufällige Lottozahlen (1-49)
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

  // Generiert mehrere Tipps
  static List<List<int>> generateMultipleTips(int count) {
    return List.generate(count, (_) => generateLottoNumbers());
  }

  // Überprüft Gewinnklasse
  static int checkWinningClass(List<int> tip, List<int> drawing) {
    final matches = tip.where((number) => drawing.contains(number)).length;
    return matches;
  }

  // Berechnet Kosten
  static double calculateCost(int tips, double pricePerTip) {
    return tips * pricePerTip;
  }

  // Statistik: Häufigkeit der Zahlen in allen Tipps
  static Map<int, int> calculateNumberFrequency(List<List<int>> allTips) {
    final frequency = <int, int>{};
    
    for (var tip in allTips) {
      for (var number in tip) {
        frequency[number] = (frequency[number] ?? 0) + 1;
      }
    }
    
    return frequency;
  }

  // Statistik: Heiße Zahlen (am häufigsten)
  static List<int> getHotNumbers(Map<int, int> frequency, {int count = 6}) {
    final sortedEntries = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedEntries.take(count).map((e) => e.key).toList();
  }

  // Statistik: Kalte Zahlen (am seltensten)
  static List<int> getColdNumbers(Map<int, int> frequency, {int count = 6}) {
    final sortedEntries = frequency.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    
    return sortedEntries.take(count).map((e) => e.key).toList();
  }

  // Berechnet die durchschnittliche Quote pro Zahl
  static double calculateAverageFrequency(Map<int, int> frequency, int totalTips) {
    if (frequency.isEmpty) return 0.0;
    final total = frequency.values.reduce((a, b) => a + b);
    return total / frequency.length / totalTips;
  }

  // Prüft Tipp auf häufige Muster
  static Map<String, dynamic> analyzeTipPattern(List<int> tip) {
    final sortedTip = List<int>.from(tip)..sort();
    
    // Berechnte Abstände zwischen Zahlen
    final gaps = <int>[];
    for (int i = 1; i < sortedTip.length; i++) {
      gaps.add(sortedTip[i] - sortedTip[i - 1]);
    }
    
    // Analysiere Verteilung
    final lowNumbers = tip.where((n) => n <= 25).length;
    final highNumbers = tip.where((n) => n > 25).length;
    final evenNumbers = tip.where((n) => n % 2 == 0).length;
    final oddNumbers = tip.where((n) => n % 2 == 1).length;
    
    return {
      'hasConsecutive': _hasConsecutiveNumbers(sortedTip),
      'lowHighRatio': lowNumbers / highNumbers,
      'evenOddRatio': evenNumbers / oddNumbers,
      'averageGap': gaps.reduce((a, b) => a + b) / gaps.length,
      'maxGap': gaps.reduce((a, b) => a > b ? a : b),
    };
  }

  static bool _hasConsecutiveNumbers(List<int> numbers) {
    for (int i = 1; i < numbers.length; i++) {
      if (numbers[i] - numbers[i - 1] == 1) {
        return true;
      }
    }
    return false;
  }

  // Gewinnsimulation
  static Map<String, dynamic> simulateWinnings(List<List<int>> myTips, int simulations) {
    final random = Random();
    final results = <int, int>{}; // Gewinnklasse -> Anzahl
    
    for (int i = 0; i < simulations; i++) {
      // Simuliere eine Ziehung
      final drawing = generateLottoNumbers();
      
      // Prüfe alle Tipps
      for (var tip in myTips) {
        final matches = checkWinningClass(tip, drawing);
        results[matches] = (results[matches] ?? 0) + 1;
      }
    }
    
    return {
      'simulations': simulations,
      'results': results,
      'winningProbability': _calculateWinningProbability(results, simulations * myTips.length),
    };
  }

  static double _calculateWinningProbability(Map<int, int> results, int totalAttempts) {
    final winningGames = results.entries
        .where((entry) => entry.key >= 3) // 3 oder mehr Richtige = Gewinn
        .map((entry) => entry.value)
        .reduce((a, b) => a + b);
    
    return winningGames / totalAttempts;
  }
}
