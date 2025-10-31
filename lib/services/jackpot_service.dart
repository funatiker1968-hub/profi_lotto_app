class JackpotService {
  Future<Map<String, dynamic>> getCurrentJackpots() async {
    // Simulierte Jackpot-Daten mit erweiterten Informationen
    await Future.delayed(const Duration(milliseconds: 500));

    return {
      'lotto6aus49': {
        'gameName': 'Lotto 6aus49',
        'amount': 12500000.0,
        'nextDraw': DateTime.now().add(const Duration(days: 1)),
      },
      'eurojackpot': {
        'gameName': 'Eurojackpot',
        'amount': 90000000.0,
        'nextDraw': DateTime.now().add(const Duration(days: 2)),
      },
    };
  }

  String formatJackpotAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)} Mio. €';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)} Tsd. €';
    }
    return '${amount.toStringAsFixed(0)} €';
  }

  String formatNextDraw(DateTime nextDraw) {
    final now = DateTime.now();
    final difference = nextDraw.difference(now);
    
    if (difference.inDays > 0) {
      return 'in ${difference.inDays} Tagen';
    } else if (difference.inHours > 0) {
      return 'in ${difference.inHours} Stunden';
    } else {
      return 'heute';
    }
  }

  // Alte Methode für Kompatibilität
  Future<Map<String, dynamic>> getJackpots() async {
    final jackpots = await getCurrentJackpots();
    final simpleJackpots = <String, dynamic>{};
    
    jackpots.forEach((key, value) {
      simpleJackpots[key] = (value['amount'] as double) / 1000000;
    });
    
    return simpleJackpots;
  }
}
