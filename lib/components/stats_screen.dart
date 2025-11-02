import 'package:flutter/material.dart';
import '../services/historical_data_service.dart';
import '../services/lotto_system_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import 'number_chip.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final HistoricalDataService _dataService = HistoricalDataService();
  final LanguageService _languageService = LanguageService();
  final ThemeService _themeService = ThemeService();
  
  final Map<String, List<NumberStats>> _hotNumbers = {};
  final Map<String, List<NumberStats>> _coldNumbers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() async {
    final systems = LottoSystemService.getAvailableSystems();
    
    for (final system in systems) {
      // Verwende verfügbare historische Daten
      final Map<String, dynamic> exampleData = {
        'lotto6aus49': [
          {'numbers': [3, 7, 15, 23, 34, 49, 8], 'date': '2024-01-01'},
          {'numbers': [5, 12, 18, 27, 35, 42, 3], 'date': '2024-01-08'},
          {'numbers': [8, 14, 22, 29, 37, 45, 9], 'date': '2024-01-15'},
        ],
        'eurojackpot': [
          {'numbers': [5, 12, 23, 32, 45, 3, 7], 'date': '2024-01-02'},
          {'numbers': [7, 15, 24, 33, 41, 1, 8], 'date': '2024-01-09'},
        ],
        'sans_topu': [
          {'numbers': [8, 15, 24, 33, 42, 49, 12], 'date': '2024-01-03'},
          {'numbers': [3, 11, 19, 28, 36, 44, 5], 'date': '2024-01-10'},
        ]
      };
      
      final systemData = exampleData[system.id] ?? [];
      final drawings = systemData.map((data) => _createDrawing(data, system.id)).toList();
      
      final hotNumbers = _dataService.getHotNumbers(drawings);
      final coldNumbers = _dataService.getColdNumbers(drawings);
      
      setState(() {
        _hotNumbers[system.id] = hotNumbers;
        _coldNumbers[system.id] = coldNumbers;
      });
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  // Hilfsmethode zur Erstellung von Drawing-Objekten
  dynamic _createDrawing(Map<String, dynamic> data, String systemId) {
    return {
      'numbers': List<int>.from(data['numbers'] ?? []),
      'date': data['date'],
      'systemId': systemId
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik & Analyse'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              _languageService.switchLanguage();
              setState(() {});
            },
          ),
          IconButton(
            icon: Icon(_themeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              _themeService.toggleTheme();
              setState(() {});
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSystemStats('lotto6aus49', 'Lotto 6aus49'),
                  const SizedBox(height: 24),
                  _buildSystemStats('eurojackpot', 'Eurojackpot'),
                  const SizedBox(height: 24),
                  _buildSystemStats('sans_topu', 'Sayısal Loto'),
                ],
              ),
            ),
    );
  }

  Widget _buildSystemStats(String systemId, String systemName) {
    final hotNumbers = _hotNumbers[systemId] ?? [];
    final coldNumbers = _coldNumbers[systemId] ?? [];
    final system = LottoSystemService.getSystemById(systemId);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              systemName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Heiße Zahlen
            const Text(
              '🔥 Heiße Zahlen (häufig gezogen):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildNumberList(hotNumbers, system.primaryColor),
            
            const SizedBox(height: 16),
            
            // Kalte Zahlen
            const Text(
              '❄️ Kalte Zahlen (selten gezogen):',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildNumberList(coldNumbers, Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberList(List<NumberStats> stats, Color color) {
    if (stats.isEmpty) {
      return const Text('Demo-Daten werden geladen...');
    }
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: stats.take(6).map((stat) => buildNumberChip(
        stat.number,
        primaryColor: color,
        isBall: true,
      )).toList(),
    );
  }
}
