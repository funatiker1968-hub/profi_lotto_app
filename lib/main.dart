import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'lotto_service.dart';
import 'stats_screen.dart';
import 'tip_analysis_screen.dart';
import 'l10n/app_localizations.dart';

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
  Locale _locale = const Locale('de');

  void _changeLanguage(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lotto World Pro',
      themeMode: _mode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('de'),
        Locale('en'),
        Locale('tr'),
      ],
      home: LottoHomeScreen(
        onThemeChanged: (mode) {
          setState(() {
            _mode = mode;
          });
        },
        onLanguageChanged: _changeLanguage,
        currentLocale: _locale,
      ),
    );
  }
}

class LottoHomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final Function(Locale) onLanguageChanged;
  final Locale currentLocale;

  const LottoHomeScreen({
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.currentLocale,
  });

  @override
  State<LottoHomeScreen> createState() => _LottoHomeScreenState();
}

class _LottoHomeScreenState extends State<LottoHomeScreen> {
  List<int> _currentNumbers = [];
  List<List<int>> _myTips = [];
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
      _totalCost = LottoService.calculateCost(_myTips.length, 1.50);
    });
  }

  void _saveTip() {
    if (_currentNumbers.isNotEmpty) {
      setState(() {
        _myTips.add(List.from(_currentNumbers));
        _totalCost = LottoService.calculateCost(_myTips.length, 1.50);
      });
      _showSuccessSnackbar(AppLocalizations.of(context)!.tipSaved);
    }
  }

  void _clearTips() {
    setState(() {
      _myTips.clear();
      _totalCost = 0.0;
    });
    _showSuccessSnackbar(AppLocalizations.of(context)!.allTipsDeleted);
  }

  void _generateMultipleTips(int count) {
    setState(() {
      final newTips = LottoService.generateMultipleTips(count);
      _myTips.addAll(newTips);
      _totalCost = LottoService.calculateCost(_myTips.length, 1.50);
    });
    _showSuccessSnackbar(AppLocalizations.of(context)!.tipsGenerated);
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
        border: Border.all(color: const Color(0xFFB8860B), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
          BoxShadow(
            color: const Color(0xFFFFD700).withOpacity(0.3),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Text(
          number.toString().padLeft(2, '0'),
          style: TextStyle(
            color: const Color(0xFF8B4513),
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
        style: const TextStyle(
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
        color: const Color(0xFF2D2D2D),
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
                Icon(icon, color: const Color(0xFFFFD700), size: 24),
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
    if (_myTips.isEmpty) {
      _showSuccessSnackbar(AppLocalizations.of(context)!.createTipsFirst);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StatsScreen(allTips: _myTips),
      ),
    );
  }

  void _navigateToTipAnalysis() {
    if (_myTips.isEmpty) {
      _showSuccessSnackbar(AppLocalizations.of(context)!.createTipsFirst);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TipAnalysisScreen(allTips: _myTips),
      ),
    );
  }

  void _showWinningSimulation() {
    if (_myTips.isEmpty) {
      _showSuccessSnackbar(AppLocalizations.of(context)!.createTipsFirst);
      return;
    }

    final simulation = LottoService.simulateWinnings(_myTips, 10000);
    final probability = simulation['winningProbability'] * 100;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: Text(
          AppLocalizations.of(context)!.winSimulation,
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSimulationRow('${AppLocalizations.of(context)!.totalTips}:', '${_myTips.length}'),
            _buildSimulationRow('Simulations:', '10,000'),
            _buildSimulationRow('Winning probability:', '${probability.toStringAsFixed(2)}%'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: const TextStyle(color: Color(0xFFFFD700)),
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

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: Text(
          '⚙️ EINSTELLUNGEN',
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSettingsOption('🌍 Sprache wechseln', Icons.language, () {
              Navigator.of(context).pop();
              _showLanguageSelectionDialog();
            }),
            
            const SizedBox(height: 12),
            
            _buildSettingsOption('🚪 App beenden', Icons.exit_to_app, () {
              Navigator.of(context).pop();
              _showExitConfirmationDialog();
            }),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: Text(
          '🌍 SPRACHE WÄHLEN',
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('🇩🇪 Deutsch', const Locale('de')),
            _buildLanguageOption('🇬🇧 English', const Locale('en')),
            _buildLanguageOption('🇹🇷 Türkçe', const Locale('tr')),
          ],
        ),
      ),
    );
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text(
          '🚪 APP BEENDEN',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Möchtest du die App wirklich beenden?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'ABBRECHEN',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text(
              'BEENDEN',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(String title, IconData icon, VoidCallback onTap) {
    return Card(
      color: const Color(0xFF3D3D3D),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFFD700)),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLanguageOption(String label, Locale locale) {
    final isSelected = widget.currentLocale.languageCode == locale.languageCode;
    return ListTile(
      leading: isSelected ? const Icon(Icons.check, color: Color(0xFFFFD700)) : null,
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFFFFD700) : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        widget.onLanguageChanged(locale);
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.casino, color: Color(0xFFFFD700)),
            const SizedBox(width: 12),
            Text(
              l10n.appTitle,
              style: const TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2D2D2D),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.8),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFFFFD700)),
            onPressed: _showSettingsDialog,
            tooltip: 'Einstellungen',
          ),
          if (_myTips.isNotEmpty) IconButton(
            icon: const Icon(Icons.analytics, color: Color(0xFFFFD700)),
            onPressed: _navigateToStats,
            tooltip: l10n.statistics,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.palette, color: Color(0xFFFFD700)),
            onSelected: (val) {
              ThemeMode newMode;
              if (val == 'light') newMode = ThemeMode.light;
              else if (val == 'dark') newMode = ThemeMode.dark;
              else newMode = ThemeMode.system;
              
              widget.onThemeChanged(newMode);
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'light', child: Text(l10n.light)),
              PopupMenuItem(value: 'dark', child: Text(l10n.dark)),
              PopupMenuItem(value: 'system', child: Text(l10n.system)),
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
              color: const Color(0xFF2D2D2D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: Color(0xFFFFD700), width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      '🎲 ${l10n.yourWinningNumbers} 🎲',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFD700),
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _currentNumbers.isEmpty
                        ? Column(
                            children: [
                              const Icon(Icons.casino_outlined, size: 50, color: Colors.grey),
                              const SizedBox(height: 10),
                              Text(
                                l10n.pressSpinToStart,
                                style: const TextStyle(fontSize: 16, color: Colors.grey),
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
                        _buildCasinoButton(l10n.spin, Icons.casino, const Color(0xFFC41E3A), _generateNumbers),
                        _buildCasinoButton(l10n.save, Icons.save, const Color(0xFF228B22), 
                            _currentNumbers.isEmpty ? () {} : _saveTip,
                            disabled: _currentNumbers.isEmpty),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),

            Row(
              children: [
                _buildNavigationButton(l10n.statistics, Icons.bar_chart, _navigateToStats),
                const SizedBox(width: 10),
                _buildNavigationButton(l10n.tipAnalysis, Icons.analytics, _navigateToTipAnalysis),
                const SizedBox(width: 10),
                _buildNavigationButton(l10n.winSimulation, Icons.attach_money, _showWinningSimulation),
              ],
            ),
            
            const SizedBox(height: 20),

            Card(
              elevation: 6,
              color: const Color(0xFF2D2D2D),
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
                        Text('🎫 ${l10n.tips}', style: const TextStyle(color: Colors.grey)),
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
                        Text('💰 ${l10n.cost}', style: const TextStyle(color: Colors.grey)),
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
                  child: _buildCasinoButton('5 ${l10n.quickTips}', Icons.fast_forward, const Color(0xFFFF8C00), 
                      () => _generateMultipleTips(5)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildCasinoButton('10 ${l10n.megaTips}', Icons.flash_on, const Color(0xFFDC143C), 
                      () => _generateMultipleTips(10)),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, const Color(0xFFFFD700), Colors.transparent],
                ),
              ),
            ),
            
            const SizedBox(height: 15),
            
            Text(
              '💎 ${l10n.myWinningTips} 💎',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFD700),
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            
            Expanded(
              child: _myTips.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.celebration_outlined, size: 60, color: Colors.grey),
                          const SizedBox(height: 15),
                          Text(
                            l10n.noTipsYet,
                            style: const TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            l10n.generateLuckyNumbers,
                            style: const TextStyle(color: Colors.grey),
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
                          color: const Color(0xFF2D2D2D),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: Colors.grey[700]!, width: 1),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFFFFD700),
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
