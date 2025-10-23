class JackpotService {
  // Aktuelle Jackpot-Daten abrufen
  Future<Map<String, dynamic>> getCurrentJackpots() async {
    // Beispiel-Daten - später durch echte API ersetzen
    return {
      'lotto6aus49': {
        'amount': 45000000, // 45 Millionen Euro
        'currency': 'EUR',
        'nextDraw': '2024-01-20T18:00:00Z',
        'game': 'Lotto 6aus49',
        'gameName': 'Lotto 6aus49'
      },
      'eurojackpot': {
        'amount': 90000000, // 90 Millionen Euro
        'currency': 'EUR', 
        'nextDraw': '2024-01-19T20:00:00Z',
        'game': 'Eurojackpot',
        'gameName': 'Eurojackpot'
      }
    };
  }
  
  // Prüfen ob Jackpot hoch ist
  bool isJackpotHigh(Map<String, dynamic> jackpot, int threshold) {
    return jackpot['amount'] >= threshold;
  }

  // Formatierte Anzeige des Betrags
  String formatJackpotAmount(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)} Mio. €';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)} T €';
    }
    return '$amount €';
  }

  // Nächste Ziehung formatieren
  String formatNextDraw(String drawDate) {
    final date = DateTime.parse(drawDate);
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
