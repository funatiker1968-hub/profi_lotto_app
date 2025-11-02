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
  
  // Cache für Statistiken - verhindert Neugenerierung bei Sprach/Theme-Änderung
  final Map<String, Map<String, dynamic>> _statsCache = {};

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onUpdate);
    _themeService.addListener(_onUpdate);
    
    // Initialisiere Cache für alle Systeme
    for (final system in _systems) {
      _statsCache[system.id] = HistoricalDataService.analyzeHistoricalData(system.id);
    }
  }

  @override
  void dispose() {
    _languageService.removeListener(_onUpdate);
    _themeService.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    setState(() {}); // Nur UI aktualisieren, keine Daten neu generieren
  }

  Map<String, dynamic> get _currentStats {
    // Verwende gecachte Daten statt neu zu generieren
    return _statsCache[_selectedSystem.id] ?? {};
  }

  @override
  Widget build(BuildContext context) {
    final stats = _currentStats;
    final hotNumbers = List<int>.from(stats['hotNumbers'] ?? []);
    final coldNumbers = List<int>.from(stats['coldNumbers'] ?? []);
    final hotBonusNumbers = List<int>.from(stats['hotBonusNumbers'] ?? []);
    final coldBonusNumbers = List<int>.from(stats['coldBonusNumbers'] ?? []);
    final totalDraws = stats['totalDraws'] ?? 0;

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

            // Analyse-Info
            Card(
              color: Colors.blue.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📊 Statistik-Info',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Basierend auf historischen Daten der letzten 10 Jahre',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Daten werden nur beim Systemwechsel neu geladen',
                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
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
                        _buildStatItem('Analysierte\nZiehungen', totalDraws.toString()),
                        _buildStatItem('Zeitraum', '10 Jahre'),
                        _buildStatItem('System', _selectedSystem.name),
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
                    Text(
                      _languageService.getTranslation('hotNumbers'),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${_languageService.getTranslation('mostFrequentlyDrawn')}',
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
                      '${_languageService.getTranslation('leastFrequentlyDrawn')}',
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
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(Icons.info, color: Colors.blue, size: 24),
                    SizedBox(height: 8),
                    Text(
                      'Diese Statistik basiert auf historischen Ziehungsdaten. Vergangene Ergebnisse sind kein Indikator für zukünftige Gewinne.',
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
