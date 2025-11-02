import 'package:flutter/material.dart';
import 'number_chip.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../services/lotto_system_service.dart';
import '../services/jackpot_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import 'lotto_tip_screen.dart';
import 'stats_screen.dart';

class JackpotOverviewScreen extends StatefulWidget {
  const JackpotOverviewScreen({super.key});

  @override
  State<JackpotOverviewScreen> createState() => _JackpotOverviewScreenState();
}

class _JackpotOverviewScreenState extends State<JackpotOverviewScreen> with TickerProviderStateMixin {
  final LanguageService _languageService = LanguageService();
  final ThemeService _themeService = ThemeService();
  final List<LottoSystem> _systems = LottoSystemService.getAvailableSystems();
  late AnimationController _timerController;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    
    // Listener für Sprach- und Theme-Änderungen
    _languageService.addListener(_onUpdate);
    _themeService.addListener(_onUpdate);
  }

  @override
  void dispose() {
    _timerController.dispose();
    _languageService.removeListener(_onUpdate);
    _themeService.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    setState(() {});
  }

  void _switchLanguage() {
    _languageService.switchLanguage();
  }

  void _toggleTheme() {
    _themeService.toggleTheme();
  }

  void _navigateToStats() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StatsScreen()),
    );
  }

  String _formatNumber(dynamic number) {
    if (number is String) return number;
    if (number is int) return '€${number.toStringAsFixed(0)}';
    if (number is double) return '€${number.toStringAsFixed(2)}';
    return 'N/A';
  }

  String _formatCountdown(DateTime nextDraw) {
    final now = DateTime.now();
    final difference = nextDraw.difference(now);
    
    if (difference.isNegative) {
      return 'Läuft...';
    }
    
    final days = difference.inDays;
    final hours = difference.inHours.remainder(24);
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);
    
    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m ${seconds}s';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else {
      return '${minutes}m ${seconds}s';
    }
  }

  Widget _buildSystemCard(LottoSystem system) {
    final jackpotData = JackpotService.getJackpotData(system.id);
    final currentJackpot = jackpotData['currentJackpot'] ?? 'N/A';
    final nextDraw = jackpotData['nextDraw'] as DateTime;
    final lastDraws = List<Map<String, dynamic>>.from(jackpotData['lastDraws'] ?? []);
    final lastDraw = lastDraws.isNotEmpty ? lastDraws.first : null;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header mit Systemname und Jackpot
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: system.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      system.name.substring(0, 1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        system.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        system.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Jackpot',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      _formatNumber(currentJackpot),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Zahlenbereich Info
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        'Hauptzahlen',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '${system.mainNumbersCount} aus ${system.mainNumbersMax}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (system.hasBonusNumbers) ...[
                    Column(
                      children: [
                        Text(
                          _getBonusLabel(system),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          '${system.bonusNumbersCount} aus ${system.bonusNumbersMax}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                  Column(
                    children: [
                      Text(
                        'Ziehung',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        system.schedule,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Letzte Ziehung
            if (lastDraw != null) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Letzte Ziehung:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (lastDraw['date'] != null) 
                    Text(
                      "Ziehungsdatum: ${DateFormat('dd.MM.yyyy').format(lastDraw['date'] as DateTime)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  const SizedBox(height: 8),
                  
                  // Hauptzahlen
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
