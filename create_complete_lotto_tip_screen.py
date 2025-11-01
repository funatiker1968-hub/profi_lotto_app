complete_code = '''import 'package:flutter/material.dart';
import '../services/lotto_system_service.dart';
import '../services/lotto_service.dart';
import '../services/storage_service.dart';
import '../services/language_service.dart';

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
  Map<String, List<int>> _currentTip = {};
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
      _currentTip = _lottoService.generateTipForSystem(widget.selectedSystem) as Map<String, List<int>>;
    });

    // Tipp speichern - Haupt- und Bonus-Zahlen getrennt
    final allNumbers = [
      ..._currentTip['mainNumbers'] ?? [],
      ..._currentTip['bonusNumbers'] ?? []
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
      _currentTip = {};
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

  Widget _buildNumberChip(int number, {bool isBonus = false}) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isBonus 
            ? Colors.orange.shade300 
            : widget.selectedSystem.primaryColor,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedSystem.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
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
                          
                          // Hauptzahlen
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ...?_currentTip['mainNumbers']?.map((number) => _buildNumberChip(number, isBonus: false)).toList(),
                              ...?_currentTip['bonusNumbers']?.map((number) => _buildNumberChip(number, isBonus: true)).toList(),
                            ],
                          ),
                          
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
                  
                  // Tipp-Historie
                  Text(
                    'Tipp-Historie:',
                    style: Theme.of(context).textTheme.titleLarge,
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
                            children: numbers.map((number) => _buildNumberChip(number)).toList(),
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
                    }),
                ],
              ),
            ),
    );
  }
  
  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'Unbekannt';
    final date = DateTime.parse(timestamp.toString());
    return '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
'''

with open('lib/components/lotto_tip_screen.dart', 'w') as f:
    f.write(complete_code)

print("✅ Vollständige, korrekte LottoTipScreen Version erstellt")
