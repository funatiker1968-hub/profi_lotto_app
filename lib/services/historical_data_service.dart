import '../models/lottery_drawing.dart';

class NumberStats {
  final int number;
  final int frequency;
  final double percentage;
  final int lastSeenDaysAgo;
  final bool isHot;
  final bool isCold;

  const NumberStats({
    required this.number,
    required this.frequency,
    required this.percentage,
    required this.lastSeenDaysAgo,
    required this.isHot,
    required this.isCold,
  });
}

class HistoricalDataService {
  
  // Analysiert Zahlenhäufigkeiten basierend auf historischen Ziehungen
  List<NumberStats> analyzeNumberFrequencies(List<LotteryDrawing> drawings) {
    final frequencyMap = <int, int>{};
    final lastSeenMap = <int, DateTime>{};
    final now = DateTime.now();
    
    // Zähle Häufigkeiten und letztes Erscheinen
    for (final drawing in drawings) {
      for (final number in drawing.numbers) {
        frequencyMap[number] = (frequencyMap[number] ?? 0) + 1;
        lastSeenMap[number] = drawing.date;
      }
      if (drawing.bonusNumbers != null) {
        for (final number in drawing.bonusNumbers!) {
          frequencyMap[number] = (frequencyMap[number] ?? 0) + 1;
          lastSeenMap[number] = drawing.date;
        }
      }
    }
    
    // Berechne Statistiken
    final totalDrawings = drawings.length;
    final stats = frequencyMap.entries.map((entry) {
      final number = entry.key;
      final frequency = entry.value;
      final percentage = (frequency / totalDrawings) * 100;
      final lastSeen = lastSeenMap[number]!;
      final daysSinceLastSeen = now.difference(lastSeen).inDays;
      
      return NumberStats(
        number: number,
        frequency: frequency,
        percentage: percentage,
        lastSeenDaysAgo: daysSinceLastSeen,
        isHot: false, // Wird später gesetzt
        isCold: false, // Wird später gesetzt
      );
    }).toList();
    
    // Sortiere nach Häufigkeit
    stats.sort((a, b) => b.frequency.compareTo(a.frequency));
    
    // Bestimme Hot/Cold Zahlen (obere/untere 20%)
    final hotThreshold = (stats.length * 0.2).floor();
    final coldThreshold = (stats.length * 0.2).floor();
    
    for (int i = 0; i < stats.length; i++) {
      if (i < hotThreshold) {
        stats[i] = NumberStats(
          number: stats[i].number,
          frequency: stats[i].frequency,
          percentage: stats[i].percentage,
          lastSeenDaysAgo: stats[i].lastSeenDaysAgo,
          isHot: true,
          isCold: false,
        );
      } else if (i >= stats.length - coldThreshold) {
        stats[i] = NumberStats(
          number: stats[i].number,
          frequency: stats[i].frequency,
          percentage: stats[i].percentage,
          lastSeenDaysAgo: stats[i].lastSeenDaysAgo,
          isHot: false,
          isCold: true,
        );
      }
    }
    
    return stats;
  }
  
  // Gibt die heißesten Zahlen zurück
  List<NumberStats> getHotNumbers(List<LotteryDrawing> drawings, {int count = 6}) {
    final stats = analyzeNumberFrequencies(drawings);
    return stats.where((stat) => stat.isHot).take(count).toList();
  }
  
  // Gibt die kältesten Zahlen zurück
  List<NumberStats> getColdNumbers(List<LotteryDrawing> drawings, {int count = 6}) {
    final stats = analyzeNumberFrequencies(drawings);
    return stats.where((stat) => stat.isCold).take(count).toList();
  }
  
  // Berechnet häufigste Zahlenpaare
  Map<String, int> analyzeNumberPairs(List<LotteryDrawing> drawings) {
    final pairCounts = <String, int>{};
    
    for (final drawing in drawings) {
      final numbers = drawing.numbers;
      numbers.sort();
      
      // Zähle alle möglichen Paare in dieser Ziehung
      for (int i = 0; i < numbers.length - 1; i++) {
        for (int j = i + 1; j < numbers.length; j++) {
          final pair = '${numbers[i]}-${numbers[j]}';
          pairCounts[pair] = (pairCounts[pair] ?? 0) + 1;
        }
      }
    }
    
    return pairCounts;
  }
  
  // Gibt die häufigsten Zahlenpaare zurück
  List<MapEntry<String, int>> getTopNumberPairs(List<LotteryDrawing> drawings, {int count = 10}) {
    final pairCounts = analyzeNumberPairs(drawings);
    final sortedPairs = pairCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedPairs.take(count).toList();
  }
}
