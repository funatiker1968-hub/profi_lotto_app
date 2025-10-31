class LotteryDrawing {
  final String id;
  final DateTime date;
  final List<int> numbers;
  final List<int>? bonusNumbers;
  final String lotteryType;

  LotteryDrawing({
    required this.id,
    required this.date,
    required this.numbers,
    this.bonusNumbers,
    required this.lotteryType,
  });

  factory LotteryDrawing.fromJson(Map<String, dynamic> json) {
    return LotteryDrawing(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      numbers: List<int>.from(json['numbers'] ?? []),
      bonusNumbers: json['bonusNumbers'] != null 
          ? List<int>.from(json['bonusNumbers'])
          : null,
      lotteryType: json['lotteryType'] ?? 'Lotto',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'numbers': numbers,
      'bonusNumbers': bonusNumbers,
      'lotteryType': lotteryType,
    };
  }
}
