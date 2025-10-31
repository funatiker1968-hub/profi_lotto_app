class TipAnalysisService {
  
  // Analysiert alle gespeicherten Tipps und erstellt Statistiken
  Map<String, dynamic> analyzeTips(List<Map<String, dynamic>> tips) {
    if (tips.isEmpty) {
      return {
        'totalTips': 0,
        'message': 'Keine Tipps zur Analyse vorhanden',
        'mostFrequentNumbers': [],
        'numberFrequency': {},
        'analysisDate': DateTime.now(),
      };
    }

    // Zahlen-Häufigkeit berechnen
    final numberFrequency = <int, int>{};
    for (final tip in tips) {
      final numbers = List<int>.from(tip['numbers'] ?? []);
      for (final number in numbers) {
        numberFrequency[number] = (numberFrequency[number] ?? 0) + 1;
      }
    }

    // Häufigste Zahlen finden
    final sortedNumbers = numberFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final mostFrequent = sortedNumbers.take(6).map((e) => e.key).toList();
    final leastFrequent = sortedNumbers.reversed.take(6).map((e) => e.key).toList();

    // Zeitliche Verteilung analysieren
    final tipsByWeekday = <int, int>{};
    for (final tip in tips) {
      final date = tip['date'] is DateTime ? tip['date'] : DateTime.parse(tip['date']);
      final weekday = date.weekday;
      tipsByWeekday[weekday] = (tipsByWeekday[weekday] ?? 0) + 1;
    }

    return {
      'totalTips': tips.length,
      'mostFrequentNumbers': mostFrequent,
      'leastFrequentNumbers': leastFrequent,
      'numberFrequency': numberFrequency,
      'tipsByWeekday': tipsByWeekday,
      'averageNumbersPerTip': _calculateAverageNumbers(tips),
      'analysisDate': DateTime.now(),
      'dateRange': _getDateRange(tips),
    };
  }

  double _calculateAverageNumbers(List<Map<String, dynamic>> tips) {
    if (tips.isEmpty) return 0;
    final totalNumbers = tips.fold(0, (sum, tip) => sum + (List.from(tip['numbers']).length));
    return totalNumbers / tips.length;
  }

  Map<String, DateTime> _getDateRange(List<Map<String, dynamic>> tips) {
    if (tips.isEmpty) return {'start': DateTime.now(), 'end': DateTime.now()};
    
    DateTime? earliest;
    DateTime? latest;
    
    for (final tip in tips) {
      final date = tip['date'] is DateTime ? tip['date'] : DateTime.parse(tip['date']);
      if (earliest == null || date.isBefore(earliest)) earliest = date;
      if (latest == null || date.isAfter(latest)) latest = date;
    }
    
    return {'start': earliest!, 'end': latest!};
  }

  // ÖFFENTLICHE Methode für Datumsformatierung
  String formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  // Erstellt eine Zusammenfassung der Analyse
  Map<String, dynamic> getAnalysisSummary(Map<String, dynamic> analysis) {
    return {
      'summary': 'Analyse von ${analysis['totalTips']} Tipps',
      'topNumbers': analysis['mostFrequentNumbers'],
      'dateRange': '${formatDate(analysis['dateRange']['start'])} - ${formatDate(analysis['dateRange']['end'])}',
      'averageNumbers': analysis['averageNumbersPerTip'].toStringAsFixed(1),
    };
  }
}
