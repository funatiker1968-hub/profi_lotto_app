import 'package:flutter/material.dart';
import 'dart:math';

class LottoSystem {
  final String id;
  final String name;
  final String description;
  final int mainNumbersCount;
  final int mainNumbersMax;
  final bool hasBonusNumbers;
  final int bonusNumbersCount;
  final int bonusNumbersMax;
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
      country: 'DE',
      currency: 'EUR',
      schedule: 'Mittwochs & Samstags',
      primaryColor: Colors.blue,
    ),
    'eurojackpot': const LottoSystem(
      id: 'eurojackpot',
      name: 'Eurojackpot',
      description: 'Europäischer Jackpot',
      mainNumbersCount: 5,
      mainNumbersMax: 50,
      hasBonusNumbers: true,
      bonusNumbersCount: 2,
      bonusNumbersMax: 12,
      country: 'EU',
      currency: 'EUR',
      schedule: 'Freitags',
      primaryColor: Colors.orange,
    ),
    'sayisalloto': const LottoSystem(
      id: 'sayisalloto',
      name: 'Sayısal Loto',
      description: 'Türkisches Zahlenlotto',
      mainNumbersCount: 6,
      mainNumbersMax: 49,
      hasBonusNumbers: false,
      country: 'TR',
      currency: 'TRY',
      schedule: 'Dienstags & Freitags',
      primaryColor: Colors.red,
    ),
    'sanstopu': const LottoSystem(
      id: 'sanstopu',
      name: 'Şans Topu',
      description: 'Türkisches Glücksball Lotto',
      mainNumbersCount: 5,
      mainNumbersMax: 34,
      hasBonusNumbers: true,
      bonusNumbersCount: 1,
      bonusNumbersMax: 14,
      country: 'TR',
      currency: 'TRY',
      schedule: 'Montags & Donnerstags',
      primaryColor: Colors.purple,
    ),
  };

  static List<LottoSystem> getAvailableSystems() {
    return _systems.values.toList();
  }

  static LottoSystem getSystem(String id) {
    return _systems[id] ?? _systems['lotto6aus49']!;
  }

  static List<int> generateNumbers(LottoSystem system) {
    final numbers = <int>[];
    final random = Random();

    while (numbers.length < system.mainNumbersCount) {
      final number = random.nextInt(system.mainNumbersMax) + 1;
      if (!numbers.contains(number)) {
        numbers.add(number);
      }
    }
    numbers.sort();

    return numbers;
  }

  static List<int> generateBonusNumbers(LottoSystem system) {
    if (!system.hasBonusNumbers) return [];

    final numbers = <int>[];
    final random = Random();

    while (numbers.length < system.bonusNumbersCount) {
      final number = random.nextInt(system.bonusNumbersMax) + 1;
      if (!numbers.contains(number)) {
        numbers.add(number);
      }
    }
    numbers.sort();

    return numbers;
  }
}
