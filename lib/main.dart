import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lotto_service.dart';
import 'stats_screen.dart';
import 'tip_analysis_screen.dart';

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
  int _currentIndex = 0;

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
      _showSuccessSnackbar('Tipp gespeichert!');
    }
  }

  void _clearTips() {
    setState(() {
      _myTips.clear();
      _totalCost = 0.0;
    });
    _showSuccessSnackbar('Alle Tipps gelöscht!');
  }

  void _generateMultipleTips(int count) {
    setState(() {
      final newTips = LottoService.generateMultipleTips(count);
      _myTips.addAll(newTips);
      _totalCost = LottoService.calculateCost(_myTips.length, 1.50);
    });
    _showSuccessSnackbar('$count Tipps generiert!');
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green[700],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildLottoBall(int number, {double size = 40.0}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          colors: [Colors.white, Color(0xFFFFD700)],
          stops: [0.1, 1.0],
        ),
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(color: Color(0xFFB8860B), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
          BoxShadow(
            color: Color(0xFFFFD700).withOpacity(0.3),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Text(
          number.toString().padLeft(2, '0'),
          style: TextStyle(
            color: Color(0xFF8B4513),
            fontWeight: FontWeight.bold,
            fontSize: size * 0.35,
          ),
        ),
      ),
    );
  }

  Widget _buildCasinoButton(String text, IconData icon, Color color, VoidCallback onPressed, {bool disabled = false}) {
    return ElevatedButton.icon(
      onPressed: disabled ? null : onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: disabled ? Colors.grey[600] : color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
    );
  }

  Widget _buildNavigationButton(String title, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: Card(
        elevation: 4,
        color: Color(0xFF2D2D2D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey[700]!, width: 1),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Color(0xFFFFD700), size: 24),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToStats() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StatsScreen(allTips: _myTips),
      ),
    );
  }

  void _navigateToTipAnalysis() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TipAnalysisScreen(allTips: _myTips),
      ),
    );
  }

  void _showWinningSimulation() {
    if (_myTips.isEmpty) {
      _showSuccessSnackbar('Erstelle zuerst einige Tipps!');
      return;
    }

    final simulation = LottoService.simulateWinnings(_myTips, 10000);
    final probability = simulation['winningProbability'] * 100;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2D2D2D),
        title: const Text(
          '🎰 GEWINNSIMULATION',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSimulationRow('Simulationen:', '10.000'),
            _buildSimulationRow('Deine Tipps:', '${_myTips.length}'),
            _buildSimulationRow('Gewinnwahrscheinlichkeit:', '${probability.toStringAsFixed(2)}%'),
            const SizedBox(height: 16),
            const Text(
              'Ergebnisse pro Gewinnklasse:',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            ..._buildSimulationResults(simulation['results']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'SCHLIESSEN',
              style: TextStyle(color: Color(0xFFFFD700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  List<Widget> _buildSimulationResults(Map<int, int> results) {
    final sortedResults = results.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));
    
    return sortedResults.map((entry) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${entry.key} Richtige:', style: const TextStyle(color: Colors.grey)),
          Text('${entry.value}x', style: const TextStyle(color: Color(0xFFFFD700))),
        ],
      ),
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.casino, color: Color(0xFFFFD700)),
            SizedBox(width: 12),
            Text(
              'CASINO LOTTO PRO',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF2D2D2D),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.8),
        actions: [
          if (_myTips.isNotEmpty) IconButton(
            icon: const Icon(Icons.analytics, color: Color(0xFFFFD700)),
            onPressed: _navigateToStats,
            tooltip: 'Statistik anzeigen',
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.palette, color: Color(0xFFFFD700)),
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
              elevation: 8,
              color: Color(0xFF2D2D2D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Color(0xFFFFD700), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      '🎲 DEINE GEWINNZAHLEN 🎲',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFD700),
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _currentNumbers.isEmpty
                        ? const Column(
                            children: [
                              Icon(Icons.casino_outlined, size: 50, color: Colors.grey),
                              SizedBox(height: 10),
                              Text(
                                'Drücke "SPIN" um zu starten',
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: _currentNumbers
                                .map((number) => _buildLottoBall(number))
                                .toList(),
                          ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCasinoButton('SPIN', Icons.casino, Color(0xFFC41E3A), _generateNumbers),
                        _buildCasinoButton('SPEICHERN', Icons.save, Color(0xFF228B22), 
                            _currentNumbers.isEmpty ? () {} : _saveTip,
                            disabled: _currentNumbers.isEmpty),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            // Navigation zu erweiterten Features
            Row(
              children: [
                _buildNavigationButton('STATISTIK', Icons.bar_chart, _navigateToStats),
                const SizedBox(width: 10),
                _buildNavigationButton('TIPP ANALYSE', Icons.analytics, _navigateToTipAnalysis),
                const SizedBox(width: 10),
                _buildNavigationButton('GEWINN-SIM', Icons.attach_money, _showWinningSimulation),
              ],
            ),
            
            const SizedBox(height: 20),

            Card(
              elevation: 6,
              color: Color(0xFF2D2D2D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey[700]!, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('🎫 TIPPS', style: TextStyle(color: Colors.grey)),
                        Text(
                          '${_myTips.length}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD700),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('💰 EINSATZ', style: TextStyle(color: Colors.grey)),
                        Text(
                          '${_totalCost.toStringAsFixed(2)} €',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD700),
                          ),
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
                  child: _buildCasinoButton('5 QUICK TIPPS', Icons.fast_forward, Color(0xFFFF8C00), 
                      () => _generateMultipleTips(5)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildCasinoButton('10 MEGA TIPPS', Icons.flash_on, Color(0xFFDC143C), 
                      () => _generateMultipleTips(10)),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Color(0xFFFFD700), Colors.transparent],
                ),
              ),
            ),
            
            const SizedBox(height: 15),
            
            const Text(
              '💎 MEINE GEWINNTIPPS 💎',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            
            Expanded(
              child: _myTips.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.celebration_outlined, size: 60, color: Colors.grey),
                          SizedBox(height: 15),
                          Text(
                            'Noch keine Tipps',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Generiere deine Glückszahlen!',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _myTips.length,
                      itemBuilder: (context, index) {
                        final tip = _myTips[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          color: Color(0xFF2D2D2D),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey[700]!, width: 1),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Color(0xFFFFD700),
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: tip
                                  .map((number) => _buildLottoBall(number, size: 28))
                                  .toList(),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_forever, color: Colors.red),
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
              child: const Icon(Icons.cleaning_services),
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
              tooltip: 'Alle Tipps löschen',
              elevation: 6,
            )
          : null,
    );
  }
}
