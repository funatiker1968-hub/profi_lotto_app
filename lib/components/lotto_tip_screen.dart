import 'package:flutter/material.dart';
import '../services/lotto_system_service.dart';
import '../services/lotto_service.dart';
import '../services/storage_service.dart';
import '../services/language_service.dart';
import 'stats_screen.dart';
import 'number_chip.dart';

class LottoTipScreen extends StatefulWidget {
  final LottoSystem selectedSystem;
  final VoidCallback onBack;

  const LottoTipScreen({
    super.key,
    required this.selectedSystem,
    required this.onBack,
  });

  @override
  State<LottoTipScreen> createState() => _LottoTipScreenState();
}

class _LottoTipScreenState extends State<LottoTipScreen> {
  final LottoService _lottoService = LottoService();
  final StorageService _storageService = StorageService();
  final LanguageService _languageService = LanguageService();
  Map<String, List<int>> _currentTip = {'mainNumbers': [], 'bonusNumbers': []};
  List<Map<String, dynamic>> _tipHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTips();
    _generateNewTip();
  }

  void _loadTips() async {
    await _storageService.init();
    final tips = _storageService.getTipsBySystem(widget.selectedSystem.id);
    setState(() {
      _tipHistory = tips;
      _isLoading = false;
    });
  }

  void _generateNewTip() async {
    await _storageService.init();

    setState(() {
      _currentTip = _lottoService.generateTipForSystem(widget.selectedSystem);
    });

    // Tipp speichern
    final List<int> allNumbers = [
      ..._currentTip['mainNumbers']!,
      ..._currentTip['bonusNumbers']!
    ];
    await _storageService.saveTip(allNumbers, widget.selectedSystem);

    // Historie aktualisieren
    final updatedTips = _storageService.getTipsBySystem(widget.selectedSystem.id);
    setState(() {
      _tipHistory = updatedTips;
    });
  }

  void _clearAllTips() async {
    await _storageService.init();
    await _storageService.clearTipsBySystem(widget.selectedSystem.id);
    setState(() {
      _tipHistory.clear();
      _currentTip = {'mainNumbers': [], 'bonusNumbers': []};
    });
  }

  void _deleteSingleTip(int index) async {
    await _storageService.init();

    // Finde den globalen Index für diesen Tipp
    final allTips = _storageService.getTips();
    int globalIndex = -1;
    int systemTipCount = 0;

    for (int i = 0; i < allTips.length; i++) {
      if (allTips[i]['system'] == widget.selectedSystem.id) {
        if (systemTipCount == index) {
          globalIndex = i;
          break;
        }
        systemTipCount++;
      }
    }

    if (globalIndex != -1) {
      await _storageService.deleteTip(globalIndex);
      _loadTips();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedSystem.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              _languageService.switchLanguage();
              setState(() {});
            },
            tooltip: 'Sprache wechseln',
          ),
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StatsScreen()),
              );
            },
            tooltip: 'Statistik anzeigen',
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
                  // Aktueller Tipp
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dein Tipp:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Hauptzahlen als Kugeln
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Hauptzahlen:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: _currentTip['mainNumbers']!.map((number) {
                                  return buildNumberChip(
                                    number,
                                    primaryColor: widget.selectedSystem.primaryColor,
                                    isBall: true,
                                  );
                                }).toList(),
                              ),
                            ],
                          ),

                          // Bonus-Zahlen als Kugeln
                          if (_currentTip['bonusNumbers']!.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getBonusLabel(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: _currentTip['bonusNumbers']!.map((number) {
                                    return buildNumberChip(
                                      number, 
                                      isBonus: true, 
                                      isBall: true
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 40),

                          // Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                icon: const Icon(Icons.refresh),
                                label: const Text('Neuer Tipp'),
                                onPressed: _generateNewTip,
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.delete),
                                label: const Text('Alle löschen'),
                                onPressed: _clearAllTips,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Tipp-Historie (rechteckige Chips)
                  const Text(
                    'Tipp-Historie:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  if (_tipHistory.isEmpty)
                    const Text('Noch keine Tipps gespeichert.')
                  else
                    ..._tipHistory.asMap().entries.map((entry) {
                      final index = entry.key;
                      final tip = entry.value;
                      final numbers = List<int>.from(tip['numbers'] ?? []);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: widget.selectedSystem.primaryColor,
                            child: Text(
                              (index + 1).toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Wrap(
                            spacing: 8,
                            children: numbers.map((number) {
                              return buildHistoryNumberChip(number, widget.selectedSystem.primaryColor);
                            }).toList(),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteSingleTip(index),
                          ),
                          subtitle: Text(
                            'Erstellt: ${_formatDate(tip['timestamp'])}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    }).toList(),
                ],
              ),
            ),
    );
  }

  String _getBonusLabel() {
    switch (widget.selectedSystem.id) {
      case 'lotto6aus49':
        return 'Superzahl (0-9):';
      case 'eurojackpot':
        return 'Eurozahlen (2 aus 12):';
      case 'sans_topu':
        return 'Bonus-Zahl (1 aus 14):';
      default:
        return 'Bonus-Zahlen:';
    }
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Unbekannt';
    final date = DateTime.parse(timestamp.toString());
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
