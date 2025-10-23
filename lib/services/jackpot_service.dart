class JackpotService {
  // Aktuelle Jackpot-Daten abrufen
  Future<Map<String, dynamic>> getCurrentJackpots() async {
    // AKTUALISIERTE DATEN - 2025
    return {
      'lotto6aus49': {
        'amount': 12000000, // 12 Millionen Euro - aktueller Jackpot
        'currency': 'EUR',
        'nextDraw': '2025-01-25T18:00:00Z', // Nächste Ziehung
        'game': 'Lotto 6aus49',
        'gameName': 'Lotto 6aus49'
      },
      'eurojackpot': {
        'amount': 35000000, // 35 Millionen Euro - aktueller Jackpot
        'currency': 'EUR', 
        'nextDraw': '2025-01-24T20:00:00Z', // Nächste Ziehung
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
