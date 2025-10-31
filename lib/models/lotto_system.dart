class LottoSystem {
  final String name;
  final String displayName;
  final int mainNumbersCount;
  final int mainNumbersMax;
  final bool hasExtraNumbers;
  final int extraNumbersCount;
  final int extraNumbersMax;

  const LottoSystem({
    required this.name,
    required this.displayName,
    required this.mainNumbersCount,
    required this.mainNumbersMax,
    this.hasExtraNumbers = false,
    this.extraNumbersCount = 0,
    this.extraNumbersMax = 0,
  });

  // Deutsche Lotto-Systeme
  static const LottoSystem lotto6aus49 = LottoSystem(
    name: 'lotto6aus49',
    displayName: 'Lotto 6aus49',
    mainNumbersCount: 6,
    mainNumbersMax: 49,
    hasExtraNumbers: true,
    extraNumbersCount: 1,
    extraNumbersMax: 10,
  );

  static const LottoSystem eurojackpot = LottoSystem(
    name: 'eurojackpot',
    displayName: 'Eurojackpot',
    mainNumbersCount: 5,
    mainNumbersMax: 50,
    hasExtraNumbers: true,
    extraNumbersCount: 2,
    extraNumbersMax: 12,
  );

  // Türkische Lotto-Systeme
  static const LottoSystem sayisalLoto = LottoSystem(
    name: 'sayisalLoto',
    displayName: 'Sayısal Loto',
    mainNumbersCount: 6,
    mainNumbersMax: 49,
  );

  static const LottoSystem sansTopu = LottoSystem(
    name: 'sansTopu',
    displayName: 'Şans Topu',
    mainNumbersCount: 5,
    mainNumbersMax: 34,
    hasExtraNumbers: true,
    extraNumbersCount: 1,
    extraNumbersMax: 14,
  );

  // Liste aller verfügbaren Systeme
  static List<LottoSystem> get availableSystems => [
    lotto6aus49,
    eurojackpot,
    sayisalLoto,
    sansTopu,
  ];
}
