import 'package:flutter/material.dart';
import '../services/lotto_system_service.dart';
import '../services/historical_data_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import 'number_chip.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final List<LottoSystem> _systems = LottoSystemService.getAvailableSystems();
  final LanguageService _languageService = LanguageService();
  final ThemeService _themeService = ThemeService();
  LottoSystem _selectedSystem = LottoSystemService.getAvailableSystems().first;

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onUpdate);
    _themeService.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _languageService.removeListener(_onUpdate);
    _themeService.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    setState(() {});
  }

  Map<String, dynamic> get _currentStats {
    return HistoricalDataService.analyzeHistoricalData(_selectedSystem.id);
  }

  @override
  Widget build(BuildContext context) {
    final stats = _currentStats;
    final hotNumbers = List<int>.from(stats['hotNumbers'] ?? []);
    final coldNumbers = List<int>.from(stats['coldNumbers'] ?? []);
    final hotBonusNumbers = List<int>.from(stats['hotBonusNumbers'] ?? []);
    final coldBonusNumbers = List<int>.from(stats['coldBonusNumbers'] ?? []);
    final totalDraws = stats['totalDraws'] ?? 0;
    final dateRange = Map<String, String>.from(stats['dateRange'] ?? {});

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
          IconButton(
            icon: Icon(_themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              _themeService.toggleTheme();
            },
            tooltip: 'Theme wechseln',
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
                    
                    // Hauptzahlen - Heiß
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hauptzahlen:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: hotNumbers.take(_selectedSystem.mainNumbersCount).map((number) => 
                            buildStatsNumberChip(number, isHot: true)
                          ).toList(),
                        ),
                      ],
                    ),

                    // Bonus-Zahlen - Heiß (falls vorhanden)
                    if (hotBonusNumbers.isNotEmpty && _selectedSystem.hasBonusNumbers) ...[
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getBonusLabel(_selectedSystem),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: hotBonusNumbers.take(_selectedSystem.bonusNumbersCount).map((number) => 
                              buildStatsNumberChip(number, isHot: true, isBonus: true)
                            ).toList(),
                          ),
                        ],
                      ),
                    ],
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
                    
                    // Hauptzahlen - Kalt
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hauptzahlen:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: coldNumbers.take(_selectedSystem.mainNumbersCount).map((number) => 
                            buildStatsNumberChip(number, isHot: false)
                          ).toList(),
                        ),
                      ],
                    ),

                    // Bonus-Zahlen - Kalt (falls vorhanden)
                    if (coldBonusNumbers.isNotEmpty && _selectedSystem.hasBonusNumbers) ...[
                      const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getBonusLabel(_selectedSystem),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: coldBonusNumbers.take(_selectedSystem.bonusNumbersCount).map((number) => 
                              buildStatsNumberChip(number, isHot: false, isBonus: true)
                            ).toList(),
                          ),
                        ],
                      ),
                    ],
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

  String _getBonusLabel(LottoSystem system) {
    switch (system.id) {
      case 'lotto6aus49':
        return 'Superzahl:';
      case 'eurojackpot':
        return 'Eurozahlen:';
      case 'sans_topu':
        return 'Bonus-Zahl:';
      default:
        return 'Bonus-Zahlen:';
    }
  }
}
