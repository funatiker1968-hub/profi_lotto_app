import 'package:flutter/material.dart';
import 'services/app_state.dart';
import 'services/jackpot_service.dart';
import 'lotto_service.dart';
import 'stats_screen.dart';
import 'tip_analysis_screen.dart';
import 'jackpot_settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _appState,
      builder: (context, _, child) {
        return MaterialApp(
          title: 'Lotto World Pro',
          theme: _buildTheme(false),
          darkTheme: _buildTheme(true),
          themeMode: _appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: LottoTipScreen(appState: _appState),
        );
      },
    );
  }

  ThemeData _buildTheme(bool isDark) {
    if (isDark) {
      return ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white,
        ),
          color: Colors.grey[800],
          elevation: 4,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
      );
    } else {
      return ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
          color: Colors.white,
          elevation: 4,
        ),
        scaffoldBackgroundColor: Colors.grey[50],
      );
    }
  }
}

class LottoTipScreen extends StatefulWidget {
  final AppState appState;

  const LottoTipScreen({super.key, required this.appState});

  @override
  State<LottoTipScreen> createState() => _LottoTipScreenState();
}

class _LottoTipScreenState extends State<LottoTipScreen> {
  final LottoService _lottoService = LottoService();
  final JackpotService _jackpotService = JackpotService();
  final List<Map<String, dynamic>> _myTips = [];
  List<int> _currentTip = [];
  Map<String, dynamic> _currentJackpots = {};

  @override
  void initState() {
    super.initState();
    _loadJackpots();
  }

  Future<void> _loadJackpots() async {
    final jackpots = await _jackpotService.getCurrentJackpots();
    setState(() {
      _currentJackpots = jackpots;
    });
  }

  void _generateTip() {
    setState(() {
      _currentTip = _lottoService.generateTip();
    });
  }

  void _saveTip() {
    if (_currentTip.isNotEmpty) {
      setState(() {
        _myTips.add({
          'numbers': List<int>.from(_currentTip),
          'date': DateTime.now(),
        });
        _currentTip = [];
      });
    }
  }

  void _clearTips() {
    setState(() {
      _myTips.clear();
    });
  }

  // JACKPOT CARD - GROSS UND SICHTBAR
  Widget _buildJackpotCard(Map<String, dynamic> jackpot, String gameKey) {
    final game = jackpot[gameKey];
    if (game == null) return const SizedBox.shrink();

    return Card(
      color: Colors.amber[50],
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.amber, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.attach_money, color: Colors.green[700], size: 24),
                const SizedBox(width: 8),
                Text(
                  game['gameName'] ?? gameKey,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _jackpotService.formatJackpotAmount(game['amount']),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nächste Ziehung: ${_jackpotService.formatNextDraw(game['nextDraw'])}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.appState,
      builder: (context, _, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.appState.translate('appTitle')),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            actions: [
              // JACKPOT NOTIFICATION BUTTON - NEU
              IconButton(
                icon: const Icon(Icons.attach_money),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JackpotSettingsScreen(appState: widget.appState),
                    ),
                  );
                },
                tooltip: 'Jackpot Einstellungen',
              ),
              IconButton(
                icon: Text(widget.appState.getLanguageFlag(), 
                        style: const TextStyle(fontSize: 20)),
                onPressed: widget.appState.switchLanguage,
                tooltip: widget.appState.getLanguageTooltip(),
              ),
              IconButton(
                icon: Icon(widget.appState.isDarkMode ? 
                          Icons.light_mode : Icons.dark_mode),
                onPressed: widget.appState.toggleTheme,
                tooltip: widget.appState.isDarkMode ? 
                         widget.appState.translate('lightMode') : widget.appState.translate('darkMode'),
              ),
              IconButton(
                icon: const Icon(Icons.analytics),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StatsScreen(appState: widget.appState),
                    ),
                  );
                },
                tooltip: widget.appState.translate('stats'),
              ),
              IconButton(
                icon: const Icon(Icons.insights),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TipAnalysisScreen(appState: widget.appState, tips: _myTips),
                    ),
                  );
                },
                tooltip: widget.appState.translate('analysis'),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // JACKPOT ANZEIGE - GROSS UND OBEN
                if (_currentJackpots.isNotEmpty) ...[
                  const Text(
                    '🎰 AKTUELLE JACKPOTS 🎰',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildJackpotCard(_currentJackpots, 'lotto6aus49'),
                  const SizedBox(height: 12),
                  _buildJackpotCard(_currentJackpots, 'eurojackpot'),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Colors.grey),
                  const SizedBox(height: 20),
                ],
                
                // TIPP GENERATOR
                Card(
                  color: Theme.of(context).cardTheme.color,
                  elevation: Theme.of(context).cardTheme.elevation,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          widget.appState.translate('currentTip'),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        _currentTip.isEmpty
                            ? Text(widget.appState.translate('noTip'))
                            : Text(
                                _currentTip.join(', '),
                                style: const TextStyle(fontSize: 16),
                              ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _generateTip,
                              child: Text(widget.appState.translate('generateTip')),
                            ),
                            ElevatedButton(
                              onPressed: _currentTip.isNotEmpty ? _saveTip : null,
                              child: Text(widget.appState.translate('saveTip')),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _myTips.isEmpty
                      ? Center(child: Text(widget.appState.translate('noSavedTips')))
                      : ListView.builder(
                          itemCount: _myTips.length,
                          itemBuilder: (context, index) {
                            final tip = _myTips[index];
                            return Card(
                              color: Theme.of(context).cardTheme.color,
                              elevation: Theme.of(context).cardTheme.elevation,
                              child: ListTile(
                                title: Text(tip['numbers'].join(', ')),
                                subtitle: Text(
                                    '${widget.appState.translate('created')}: ${tip['date'].toString().split(' ')[0]}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      _myTips.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (_myTips.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _clearTips,
                      child: Text(widget.appState.translate('deleteAll')),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
