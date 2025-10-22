import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lotto_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SmartLottoApp());
}

class SmartLottoApp extends StatefulWidget {
  @override
  State<SmartLottoApp> createState() => _SmartLottoAppState();
}

class _SmartLottoAppState extends State<SmartLottoApp> {
  ThemeMode _mode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Lotto Generator',
      themeMode: _mode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: LottoHomeScreen(
        onThemeChanged: (mode) {
          setState(() {
            _mode = mode;
          });
        },
      ),
    );
  }
}

class LottoHomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  const LottoHomeScreen({required this.onThemeChanged});

  @override
  State<LottoHomeScreen> createState() => _LottoHomeScreenState();
}

class _LottoHomeScreenState extends State<LottoHomeScreen> {
  List<int> _currentNumbers = [];
  List<List<int>> _myTips = [];
  int _generatedCount = 0;
  double _totalCost = 0.0;

  @override
  void initState() {
    super.initState();
    _loadMyTips();
  }

  void _loadMyTips() async {
    final prefs = await SharedPreferences.getInstance();
  }

  void _generateNumbers() {
    setState(() {
      _currentNumbers = LottoService.generateLottoNumbers();
      _generatedCount++;
      _totalCost = LottoService.calculateCost(_myTips.length, 1.50);
    });
  }

  void _saveTip() {
    if (_currentNumbers.isNotEmpty) {
      setState(() {
        _myTips.add(List.from(_currentNumbers));
        _totalCost = LottoService.calculateCost(_myTips.length, 1.50);
      });
    }
  }

  void _clearTips() {
    setState(() {
      _myTips.clear();
      _totalCost = 0.0;
    });
  }

  void _generateMultipleTips(int count) {
    setState(() {
      final newTips = LottoService.generateMultipleTips(count);
      _myTips.addAll(newTips);
      _totalCost = LottoService.calculateCost(_myTips.length, 1.50);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Lotto Generator (Profi)'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (val) {
              ThemeMode newMode;
              if (val == 'light') newMode = ThemeMode.light;
              else if (val == 'dark') newMode = ThemeMode.dark;
              else newMode = ThemeMode.system;
              
              widget.onThemeChanged(newMode);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'light', child: Text('Hell')),
              PopupMenuItem(value: 'dark', child: Text('Dunkel')),
              PopupMenuItem(value: 'system', child: Text('System')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Deine Lottozahlen',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    _currentNumbers.isEmpty
                        ? const Text('Keine Zahlen generiert')
                        : Text(
                            _currentNumbers.join(' - '),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _generateNumbers,
                          child: const Text('Neue Zahlen'),
                        ),
                        ElevatedButton(
                          onPressed: _currentNumbers.isEmpty ? null : _saveTip,
                          child: const Text('Tipp speichern'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Gespeicherte Tipps'),
                        Text(
                          '${_myTips.length}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Kosten'),
                        Text(
                          '${_totalCost.toStringAsFixed(2)} €',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _generateMultipleTips(5),
                    child: const Text('5 Tipps generieren'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _generateMultipleTips(10),
                    child: const Text('10 Tipps generieren'),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            const Divider(),
            const Text(
              'Meine gespeicherten Tipps',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            Expanded(
              child: _myTips.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.list_alt, size: 50, color: Colors.grey),
                          SizedBox(height: 10),
                          Text('Keine gespeicherten Tipps'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _myTips.length,
                      itemBuilder: (context, index) {
                        final tip = _myTips[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              tip.join(' - '),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _myTips.removeAt(index);
                                  _totalCost = LottoService.calculateCost(_myTips.length, 1.50);
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _myTips.isNotEmpty
          ? FloatingActionButton(
              onPressed: _clearTips,
              child: const Icon(Icons.clear_all),
              backgroundColor: Colors.red,
              tooltip: 'Alle Tipps löschen',
            )
          : null,
    );
  }
}
