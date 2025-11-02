import '../models/lottery_drawing.dart';
import 'lotto_system_service.dart';

class WinCheckResult {
  final bool isWinner;
  final int winTier;
  final double winAmount;
  final LotteryDrawing? matchingDrawing;
  final int matchedNumbers;
  final int matchedBonusNumbers;

  const WinCheckResult({
    required this.isWinner,
    required this.winTier,
    required this.winAmount,
    this.matchingDrawing,
    required this.matchedNumbers,
    required this.matchedBonusNumbers,
  });
}

class WinCheckService {
  // Simulierte Gewinnquoten basierend auf Lotto-System
  static final Map<String, Map<int, double>> _winTiers = {
    'lotto6aus49': {
      1: 5000000.00, // 6 Richtige + Superzahl
      2: 500000.00,  // 6 Richtige
      3: 10000.00,   // 5 Richtige + Superzahl
      4: 1000.00,    // 5 Richtige
      5: 100.00,     // 4 Richtige + Superzahl
      6: 50.00,      // 4 Richtige
      7: 10.00,      // 3 Richtige + Superzahl
      8: 5.00,       // 3 Richtige
    },
    'eurojackpot': {
      1: 10000000.00, // 5 + 2
      2: 1000000.00,  // 5 + 1
      3: 50000.00,    // 5 + 0
      4: 5000.00,     // 4 + 2
      5: 1000.00,     // 4 + 1
      6: 100.00,      // 3 + 2
      7: 50.00,       // 2 + 2
    },
    'sayisalLoto': {
      1: 20000000.00, // 6 Richtige
      2: 500000.00,   // 5 Richtige
      3: 5000.00,     // 4 Richtige
      4: 500.00,      // 3 Richtige
    },
  };

  // Prüft einen Tipp gegen eine Ziehung
  WinCheckResult checkTipAgainstDrawing({
    required List<int> tipNumbers,
    required List<int> tipBonusNumbers,
    required LotteryDrawing drawing,
    required LottoSystem system,
  }) {
    final mainMatches = _countMatches(tipNumbers, drawing.numbers);
    final bonusMatches = system.hasBonusNumbers && drawing.bonusNumbers != null
        ? _countMatches(tipBonusNumbers, drawing.bonusNumbers!)
        : 0;

    final winTier = _determineWinTier(
      mainMatches: mainMatches,
      bonusMatches: bonusMatches,
      system: system,
    );

    final winAmount = winTier > 0 ? (_winTiers[system.id]?[winTier] ?? 0.0) : 0.0;

    return WinCheckResult(
      isWinner: winTier > 0,
      winTier: winTier,
      winAmount: winAmount,
      matchingDrawing: winTier > 0 ? drawing : null,
      matchedNumbers: mainMatches,
      matchedBonusNumbers: bonusMatches,
    );
  }

  // Prüft einen Tipp gegen mehrere Ziehungen (für historische Analyse)
  List<WinCheckResult> checkTipAgainstMultipleDrawings({
    required List<int> tipNumbers,
    required List<int> tipBonusNumbers,
    required List<LotteryDrawing> drawings,
    required LottoSystem system,
  }) {
    return drawings.map((drawing) {
      return checkTipAgainstDrawing(
        tipNumbers: tipNumbers,
        tipBonusNumbers: tipBonusNumbers,
        drawing: drawing,
        system: system,
      );
    }).where((result) => result.isWinner).toList();
  }

  int _countMatches(List<int> tip, List<int> drawing) {
    return tip.where((number) => drawing.contains(number)).length;
  }

  int _determineWinTier({
    required int mainMatches,
    required int bonusMatches,
    required LottoSystem system,
  }) {
    switch (system.id) {
      case 'lotto6aus49':
        return _determine6aus49WinTier(mainMatches, bonusMatches);
      case 'eurojackpot':
        return _determineEurojackpotWinTier(mainMatches, bonusMatches);
      case 'sayisalLoto':
        return _determineSayisalLotoWinTier(mainMatches);
      default:
        return 0;
    }
  }

  int _determine6aus49WinTier(int mainMatches, int bonusMatches) {
    if (mainMatches == 6 && bonusMatches == 1) return 1;
    if (mainMatches == 6) return 2;
    if (mainMatches == 5 && bonusMatches == 1) return 3;
    if (mainMatches == 5) return 4;
    if (mainMatches == 4 && bonusMatches == 1) return 5;
    if (mainMatches == 4) return 6;
    if (mainMatches == 3 && bonusMatches == 1) return 7;
    if (mainMatches == 3) return 8;
    return 0;
  }

  int _determineEurojackpotWinTier(int mainMatches, int bonusMatches) {
    if (mainMatches == 5 && bonusMatches == 2) return 1;
    if (mainMatches == 5 && bonusMatches == 1) return 2;
    if (mainMatches == 5) return 3;
    if (mainMatches == 4 && bonusMatches == 2) return 4;
    if (mainMatches == 4 && bonusMatches == 1) return 5;
    if (mainMatches == 3 && bonusMatches == 2) return 6;
    if (mainMatches == 2 && bonusMatches == 2) return 7;
    return 0;
  }

  int _determineSayisalLotoWinTier(int mainMatches) {
    if (mainMatches == 6) return 1;
    if (mainMatches == 5) return 2;
    if (mainMatches == 4) return 3;
    if (mainMatches == 3) return 4;
    return 0;
  }

  // Berechnet Gesamtgewinne für alle Tipps
  double calculateTotalWins(List<WinCheckResult> winResults) {
    return winResults.fold(0.0, (sum, result) => sum + result.winAmount);
  }
}
