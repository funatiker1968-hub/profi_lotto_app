import 'package:flutter/material.dart';

class LottoSystem {
  final String id;
  final String name;
  final String description;
  final int mainNumbersCount;
  final int mainNumbersMax;
  final bool hasBonusNumbers;
  final int bonusNumbersCount;
  final int bonusNumbersMax;
  final int maxTipsPerGame; // Maximale Tipps pro Spiel (wie auf echtem Tippschein)
  final String country;
  final String currency;
  final String schedule;
  final Color primaryColor;

  const LottoSystem({
    required this.id,
    required this.name,
    required this.description,
    required this.mainNumbersCount,
    required this.mainNumbersMax,
    this.hasBonusNumbers = false,
    this.bonusNumbersCount = 0,
    this.bonusNumbersMax = 0,
    required this.maxTipsPerGame, // Standard: 10 Tipps pro Spiel wie auf echtem Schein
    required this.country,
    required this.currency,
    required this.schedule,
    required this.primaryColor,
  });
}

class LottoSystemService {
  static final Map<String, LottoSystem> _systems = {
    'lotto6aus49': const LottoSystem(
      id: 'lotto6aus49',
      name: 'Lotto 6aus49',
      description: 'Deutschlands klassisches Lotto',
      mainNumbersCount: 6,
      mainNumbersMax: 49,
      hasBonusNumbers: true,
      bonusNumbersCount: 1,
      bonusNumbersMax: 10,
      maxTipsPerGame: 10, // Maximal 10 Tipps wie auf echtem Schein
      country: 'DE',
      currency: 'EUR',
      schedule: 'Mittwochs & Samstags',
      primaryColor: Colors.blue,
    ),
    'eurojackpot': const LottoSystem(
      id: 'eurojackpot',
      name: 'Eurojackpot',
      description: 'Europäische Lotterie',
      mainNumbersCount: 5,
      mainNumbersMax: 50,
      hasBonusNumbers: true,
      bonusNumbersCount: 2,
      bonusNumbersMax: 10,
      maxTipsPerGame: 10, // Maximal 10 Tipps
      country: 'EU',
      currency: 'EUR',
      schedule: 'Freitags',
      primaryColor: Colors.orange,
    ),
    'sayisalLoto': const LottoSystem(
      id: 'sayisalLoto',
      name: 'Sayısal Loto',
      description: 'Türkische Zahlenlotterie',
      mainNumbersCount: 6,
      mainNumbersMax: 90,
      hasBonusNumbers: false,
      maxTipsPerGame: 8, // Türkische Scheine haben oft 8 Tipps
      country: 'TR',
      currency: 'TRY',
      schedule: 'Dienstags & Samstags',
      primaryColor: Colors.red,
    ),
  };

  static List<LottoSystem> getAvailableSystems() {
    return _systems.values.toList();
  }

  static LottoSystem getSystemById(String id) {
    return _systems[id] ?? _systems['lotto6aus49']!;
  }
}
