class JackpotService {
  // Simulierte Jackpot-Daten (können später durch API ersetzt werden)
  static final Map<String, Map<String, dynamic>> _jackpotData = {
    'lotto6aus49': {
      'currentJackpot': '45 Millionen €',
      'nextDraw': DateTime.now().add(const Duration(days: 2, hours: 20)),
      'lastDraws': [
        {
          'date': DateTime.now().subtract(const Duration(days: 3)),
          'numbers': [3, 15, 27, 33, 42, 49],
          'superzahl': 7,
          'jackpotWon': false,
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 6)),
          'numbers': [5, 12, 23, 34, 41, 48],
          'superzahl': 2,
          'jackpotWon': true,
        }
      ]
    },
    'eurojackpot': {
      'currentJackpot': '90 Millionen €',
      'nextDraw': DateTime.now().add(const Duration(days: 4, hours: 18)),
      'lastDraws': [
        {
          'date': DateTime.now().subtract(const Duration(days: 4)),
          'numbers': [7, 14, 25, 36, 43],
          'euroNumbers': [3, 8],
          'jackpotWon': false,
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 11)),
          'numbers': [2, 11, 22, 33, 44],
          'euroNumbers': [5, 9],
          'jackpotWon': false,
        }
      ]
    },
    'sayisalloto': {
      'currentJackpot': '50 Millionen ₺',
      'nextDraw': DateTime.now().add(const Duration(days: 1, hours: 15)),
      'lastDraws': [
        {
          'date': DateTime.now().subtract(const Duration(days: 4)),
          'numbers': [4, 13, 26, 35, 42, 49],
          'jackpotWon': true,
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 7)),
          'numbers': [8, 17, 29, 37, 44, 46],
          'jackpotWon': false,
        }
      ]
    },
    'sanstopu': {
      'currentJackpot': '25 Millionen ₺',
      'nextDraw': DateTime.now().add(const Duration(days: 3, hours: 12)),
      'lastDraws': [
        {
          'date': DateTime.now().subtract(const Duration(days: 3)),
          'numbers': [3, 12, 25, 31, 34],
          'bonus': 7,
          'jackpotWon': false,
        },
        {
          'date': DateTime.now().subtract(const Duration(days: 6)),
          'numbers': [5, 14, 22, 29, 33],
          'bonus': 11,
          'jackpotWon': true,
        }
      ]
    },
  };

  static Map<String, dynamic> getJackpotData(String systemId) {
    return _jackpotData[systemId] ?? _jackpotData['lotto6aus49']!;
  }

  static String getCountdown(DateTime nextDraw) {
    final now = DateTime.now();
    final difference = nextDraw.difference(now);
    
    if (difference.isNegative) {
      return 'Läuft...';
    }
    
    final days = difference.inDays;
    final hours = difference.inHours.remainder(24);
    final minutes = difference.inMinutes.remainder(60);
    
    return '${days}d ${hours}h ${minutes}m';
  }

  static String formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
