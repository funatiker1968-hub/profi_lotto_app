import 'package:flutter/material.dart';
import 'dart:math';

class LottoSystem {
  final String id;
  final String name;
  final String description;
  final int minNumbers;
  final int maxNumbers;
  final int numberRange;
  final bool hasBonusNumbers;
  final int bonusNumberRange;
  final int bonusNumbersCount;
  final String country;
  final String currency;
  final String schedule;
  final Color primaryColor;

  const LottoSystem({
    required this.id,
    required this.name,
    required this.description,
    required this.minNumbers,
    required this.maxNumbers,
    required this.numberRange,
    this.hasBonusNumbers = false,
    this.bonusNumberRange = 0,
    this.bonusNumbersCount = 0,
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
      minNumbers: 6,
      maxNumbers: 6,
      numberRange: 49,
      hasBonusNumbers: true,
      bonusNumberRange: 10,
      bonusNumbersCount: 1,
      country: 'DE',
      currency: 'EUR',
      schedule: 'Mittwochs & Samstags',
      primaryColor: Colors.blue,
    ),
    'eurojackpot': const LottoSystem(
      id: 'eurojackpot',
      name: 'Eurojackpot',
      description: 'Europäischer Jackpot',
      minNumbers: 5,
      maxNumbers: 5,
      numberRange: 50,
      hasBonusNumbers: true,
      bonusNumberRange: 12,
      bonusNumbersCount: 2,
      country: 'EU',
      currency: 'EUR',
      schedule: 'Freitags',
      primaryColor: Colors.orange,
    ),
    'sayisalloto': const LottoSystem(
      id: 'sayisalloto',
      name: 'Sayısal Loto',
      description: 'Türkisches Zahlenlotto',
      minNumbers: 6,
      maxNumbers: 6,
      numberRange: 49,
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
      minNumbers: 5,
      maxNumbers: 5,
      numberRange: 34,
      hasBonusNumbers: true,
      bonusNumberRange: 14,
      bonusNumbersCount: 1,
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
    
    while (numbers.length < system.maxNumbers) {
      final number = random.nextInt(system.numberRange) + 1;
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
      final number = random.nextInt(system.bonusNumberRange) + 1;
      if (!numbers.contains(number)) {
        numbers.add(number);
      }
    }
    numbers.sort();
    
    return numbers;
  }
}
