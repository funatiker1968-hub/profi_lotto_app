import 'package:flutter/material.dart';
import '../services/lotto_service.dart';
import '../services/lotto_system_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final LottoService _lottoService = LottoService();
  final List<LottoSystem> _systems = LottoSystemService.getAvailableSystems();
  LottoSystem _selectedSystem = LottoSystemService.getAvailableSystems().first;
  
  // Beispiel-Tipps für Demo-Statistik
  final List<List<int>> _demoTips = [
    [1, 5, 12, 23, 35, 42],
    [3, 8, 15, 27, 33, 49],
    [2, 9, 18, 29, 36, 45],
    [4, 11, 19, 28, 37, 44],
    [6, 13, 21, 30, 39, 47],
    [7, 14, 24, 31, 40, 46],
    [10, 16, 25, 32, 41, 48],
    [1, 8, 17, 26, 34, 43],
    [2, 12, 20, 29, 38, 49],
    [5, 15, 22, 30, 39, 45],
  ];

  Map<String, dynamic> get _currentStats {
    return _lottoService.analyzeTips(_demoTips);
  }

  @override
  Widget build(BuildContext context) {
    final stats = _currentStats;
    final hotNumbers = List<int>.from(stats['hotNumbers'] ?? []);
    final coldNumbers = List<int>.from(stats['coldNumbers'] ?? []);
    final totalTips = stats['totalTips'] ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik & Analyse'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // System Auswahl
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lotto System',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<LottoSystem>(
                      value: _selectedSystem,
                      isExpanded: true,
                      items: _systems.map((system) {
                        return DropdownMenuItem(
                          value: system,
                          child: Text(system.name),
                        );
                      }).toList(),
                      onChanged: (system) {
                        if (system != null) {
                          setState(() {
                            _selectedSystem = system;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Übersicht
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Statistik Übersicht',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Analysierte Tipps', totalTips.toString()),
                        _buildStatItem('Heiße Zahlen', '6'),
                        _buildStatItem('Kalte Zahlen', '6'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Heiße Zahlen
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔥 Heiße Zahlen',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Am häufigsten gezogen (basierend auf $totalTips Tipps)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: hotNumbers.map((number) => _buildNumberChip(number, isHot: true)).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Kalte Zahlen
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '❄️ Kalte Zahlen',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Am seltensten gezogen (basierend auf $totalTips Tipps)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: coldNumbers.map((number) => _buildNumberChip(number, isHot: false)).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Gewinnchance
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎰 Gewinnchancen',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _buildProbabilityItem('6 Richtige', '1 : 139.838.160'),
                    _buildProbabilityItem('5 Richtige + ZZ', '1 : 542.008'),
                    _buildProbabilityItem('5 Richtige', '1 : 60.223'),
                    _buildProbabilityItem('4 Richtige + ZZ', '1 : 10.324'),
                    _buildProbabilityItem('4 Richtige', '1 : 1.147'),
                    _buildProbabilityItem('3 Richtige + ZZ', '1 : 567'),
                    _buildProbabilityItem('3 Richtige', '1 : 63'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Info
            Card(
              color: Colors.blue.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '💡 Hinweis: Diese Statistik basiert auf analysierten Tipps. '
                  'Die Gewinnchancen sind mathematische Wahrscheinlichkeiten.',
                  style: TextStyle(fontSize: 14, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNumberChip(int number, {required bool isHot}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isHot ? Colors.red.shade400 : Colors.blue.shade400,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProbabilityItem(String chance, String probability) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(chance),
          Text(
            probability,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
