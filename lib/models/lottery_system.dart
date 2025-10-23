class LotterySystem {
  final String name;
  final int numberCount;
  final int maxNumber;
  final int bonusNumberCount;

  const LotterySystem({
    required this.name,
    required this.numberCount,
    required this.maxNumber,
    this.bonusNumberCount = 0,
  });

  static const LotterySystem lotto6aus49 = LotterySystem(
    name: 'Lotto 6aus49',
    numberCount: 6,
    maxNumber: 49,
    bonusNumberCount: 1,
  );

  static const LotterySystem eurojackpot = LotterySystem(
    name: 'Eurojackpot',
    numberCount: 5,
    maxNumber: 50,
    bonusNumberCount: 2,
  );
}
