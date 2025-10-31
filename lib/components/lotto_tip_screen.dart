import 'package:flutter/material.dart';
import '../services/lotto_service.dart';
import '../services/lotto_system_service.dart';
import '../services/storage_service.dart';

class LottoTipScreen extends StatefulWidget {
  final LottoSystem selectedSystem;

  const LottoTipScreen({
    super.key,
    required this.selectedSystem,
  });

  @override
  State<LottoTipScreen> createState() => _LottoTipScreenState();
}

class _LottoTipScreenState extends State<LottoTipScreen> {
  final LottoService _lottoService = LottoService();
  final StorageService _storageService = StorageService();
  List<int> _currentTip = [];
  List<int> _currentBonusNumbers = [];
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
      _currentBonusNumbers = widget.selectedSystem.hasBonusNumbers 
          ? LottoSystemService.generateBonusNumbers(widget.selectedSystem)
          : [];
    });

    // Tipp speichern
    final allNumbers = [..._currentTip, ..._currentBonusNumbers];
    await _storageService.saveTip(allNumbers, widget.selectedSystem);
    
    // Historie aktualisieren
    final updatedTips = _storageService.getTipsBySystem(widget.selectedSystem.id);
    setState(() {
      _tipHistory = updatedTips;
    });
  }

  void _clearHistory() async {
    await _storageService.init();
    final allTips = _storageService.getTips();
    
    // Lösche alle Tipps dieses Systems
    for (int i = allTips.length - 1; i >= 0; i--) {
      if (allTips[i]['system'] == widget.selectedSystem.id) {
        await _storageService.deleteTip(i);
      }
    }
    
    setState(() {
      _tipHistory.clear();
      _currentTip = [];
      _currentBonusNumbers = [];
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
      final updatedTips = _storageService.getTipsBySystem(widget.selectedSystem.id);
      setState(() {
        _tipHistory = updatedTips;
      });
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedSystem.name),
        backgroundColor: widget.selectedSystem.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // System Info
                Text(
                  widget.selectedSystem.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.selectedSystem.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Ziehung: ${widget.selectedSystem.schedule}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20),
                
                // Aktueller Tipp
                Text(
                  'Dein Tipp:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                
                // Hauptzahlen
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _currentTip.map((number) => _buildNumberChip(number)).toList(),
                ),
                
                // Bonus Zahlen
                if (_currentBonusNumbers.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Bonus:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: _currentBonusNumbers.map((number) => _buildNumberChip(number, isBonus: true)).toList(),
                  ),
                ],
                
                const SizedBox(height: 40),
                
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _generateNewTip,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Neuer Tipp'),
                    ),
                    if (_tipHistory.isNotEmpty)
                      ElevatedButton.icon(
                        onPressed: _clearHistory,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Alle löschen'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                  ],
                ),
                
                // Tipp Historie
                if (_tipHistory.isNotEmpty) ...[
                  const SizedBox(height: 40),
                  Text(
                    'Tipp-Historie (${_tipHistory.length}):',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  ..._tipHistory.reversed.toList().asMap().entries.map((entry) {
                    final index = entry.key;
                    final tip = entry.value;
                    final numbers = List<int>.from(tip['numbers'] ?? []);
                    final timestamp = tip['timestamp'] as String;
                    
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: widget.selectedSystem.primaryColor,
                          child: Text(
                            '${_tipHistory.length - index}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(
                          numbers.join(', '),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          _formatTimestamp(timestamp),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteSingleTip(_tipHistory.length - 1 - index),
                        ),
                      ),
                    );
                  }).toList(),
                ],

                // Keine Tipps Hinweis
                if (_tipHistory.isEmpty) ...[
                  const SizedBox(height: 40),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(Icons.history, size: 48, color: Colors.grey),
                          SizedBox(height: 10),
                          Text(
                            'Noch keine Tipps gespeichert',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          Text(
                            'Generiere deinen ersten Tipp!',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
