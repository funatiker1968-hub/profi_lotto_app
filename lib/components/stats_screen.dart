import 'package:flutter/material.dart';
import '../services/lotto_system_service.dart';
import '../services/historical_data_service.dart';
import '../services/language_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final List<LottoSystem> _systems = LottoSystemService.getAvailableSystems();
  final LanguageService _languageService = LanguageService();
  LottoSystem _selectedSystem = LottoSystemService.getAvailableSystems().first;

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

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
        title: Text(_languageService.getTranslation('statistics')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              _languageService.switchLanguage();
            },
            tooltip: 'Sprache wechseln',
          ),
        ],
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
                    Text(
                      _languageService.getTranslation('lottoSystem'),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    Text(
                      _languageService.getTranslation('analysisPeriod'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          '${_languageService.getTranslation('timePeriod')}: ${dateRange['from']} - ${dateRange['to']}',
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
                          '${_languageService.getTranslation('period')}: $analysisPeriod',
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
                          '${_languageService.getTranslation('analysis')}: $totalDraws ${_languageService.getTranslation('drawsAnalyzed')}',
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
                    Text(
                      _languageService.getTranslation('statisticsOverview'),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(_languageService.getTranslation('analyzedDraws'), totalDraws.toString()),
                        _buildStatItem(_languageService.getTranslation('averageFrequency'), averageFrequency),
                        _buildStatItem(_languageService.getTranslation('timePeriod'), '10 ${_languageService.getTranslation('years')}'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${_languageService.getTranslation('basedOnHistorical')} ${dateRange['from']} ${_languageService.getTranslation('until')} ${dateRange['to']}',
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
                    Text(
                      _languageService.getTranslation('hotNumbers'),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${_languageService.getTranslation('mostFrequentlyDrawn')} (${_languageService.getTranslation('basedOn')} $totalDraws ${_languageService.getTranslation('draws')})',
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
                      _languageService.getTranslation('hotNumbersDescription'),
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
                    Text(
                      _languageService.getTranslation('coldNumbers'),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${_languageService.getTranslation('leastFrequentlyDrawn')} (${_languageService.getTranslation('basedOn')} $totalDraws ${_languageService.getTranslation('draws')})',
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
                      _languageService.getTranslation('coldNumbersDescription'),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Info
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Icon(Icons.info, color: Colors.blue, size: 24),
                    const SizedBox(height: 8),
                    Text(
                      _languageService.getTranslation('statisticsDisclaimer'),
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
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
}
