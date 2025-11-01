import 'package:flutter/material.dart';
import '../services/lotto_system_service.dart';
import '../services/historical_data_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final List<LottoSystem> _systems = LottoSystemService.getAvailableSystems();
  LottoSystem _selectedSystem = LottoSystemService.getAvailableSystems().first;
  
  Map<String, dynamic> get _currentStats {
    return HistoricalDataService.analyzeHistoricalData(_selectedSystem.id);
  }

  Map<String, dynamic> get _currentTrends {
    return HistoricalDataService.getNumberTrends(_selectedSystem.id);
  }

  @override
  Widget build(BuildContext context) {
    final stats = _currentStats;
    final trends = _currentTrends;
    final hotNumbers = List<int>.from(stats['hotNumbers'] ?? []);
    final coldNumbers = List<int>.from(stats['coldNumbers'] ?? []);
    final totalDraws = stats['totalDraws'] ?? 0;
    final dateRange = Map<String, String>.from(stats['dateRange'] ?? {});
    final analysisPeriod = stats['analysisPeriod'] ?? 'Unbekannt';
    final averageFrequency = stats['averageFrequency'] ?? '0';

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

            // Analyse-Zeitraum
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📊 Analyse-Zeitraum',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Zeitraum: ${dateRange['from'] ?? 'N/A'} - ${dateRange['to'] ?? 'N/A'}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.analytics, size: 16, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Periode: $analysisPeriod',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.list, size: 16, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Auswertung: $totalDraws Ziehungen analysiert',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
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
                        _buildStatItem('Analysierte\nZiehungen', totalDraws.toString()),
                        _buildStatItem('Durchschnittliche\nHäufigkeit', averageFrequency),
                        _buildStatItem('Zeitraum', '10 Jahre'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Basierend auf historischen Daten von ${dateRange['from'] ?? 'N/A'} bis ${dateRange['to'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
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
                      'Am häufigsten gezogen (basierend auf $totalDraws Ziehungen)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: hotNumbers.map((number) => _buildNumberChip(number, isHot: true)).toList(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Diese Zahlen wurden im analysierten Zeitraum am häufigsten gezogen',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
                      'Am seltensten gezogen (basierend auf $totalDraws Ziehungen)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: coldNumbers.map((number) => _buildNumberChip(number, isHot: false)).toList(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Diese Zahlen wurden im analysierten Zeitraum am seltensten gezogen',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),

            // Trend Analyse
            if (trends['risingTrends'] != null && (trends['risingTrends'] as List).isNotEmpty) ...[
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📈 Aktuelle Trends',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        trends['analysisPeriod'] ?? 'Trendanalyse',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      
                      if ((trends['risingTrends'] as List).isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(Icons.trending_up, color: Colors.green, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Aufsteigend:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Wrap(
                              spacing: 6,
                              children: (trends['risingTrends'] as List<int>).map((number) => 
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    number.toString(),
                                    style: TextStyle(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      
                      if ((trends['fallingTrends'] as List).isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(Icons.trending_down, color: Colors.red, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Absteigend:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Wrap(
                              spacing: 6,
                              children: (trends['fallingTrends'] as List<int>).map((number) => 
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    number.toString(),
                                    style: TextStyle(
                                      color: Colors.red.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ).toList(),
                            ),
                          ],
                        ),
                      ],
                      
                      if ((trends['risingTrends'] as List).isEmpty && (trends['fallingTrends'] as List).isEmpty) ...[
                        const Text(
                          'Keine signifikanten Trends in den letzten Jahren festgestellt',
                          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Gewinnchance
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🎰 Mathematische Gewinnchancen',
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
                child: Column(
                  children: [
                    Icon(Icons.info, color: Colors.blue, size: 24),
                    SizedBox(height: 8),
                    Text(
                      'Diese Statistik basiert auf historischen Ziehungsdaten der letzten 10 Jahre. '
                      'Vergangene Ergebnisse sind kein Indikator für zukünftige Gewinne.',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                  ],
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
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
