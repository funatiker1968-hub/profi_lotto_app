import 'package:flutter/material.dart';
import '../services/lotto_system_service.dart';
import '../services/jackpot_service.dart';
import '../services/language_service.dart';
import 'lotto_tip_screen.dart';

class JackpotOverviewScreen extends StatefulWidget {
  const JackpotOverviewScreen({super.key});

  @override
  State<JackpotOverviewScreen> createState() => _JackpotOverviewScreenState();
}

class _JackpotOverviewScreenState extends State<JackpotOverviewScreen> {
  final LanguageService _languageService = LanguageService();
  final List<LottoSystem> _systems = LottoSystemService.getAvailableSystems();
  LottoSystem? _selectedSystem;

  void _handleSystemSelected(LottoSystem system) {
    setState(() {
      _selectedSystem = system;
    });
  }

  void _handleBackToOverview() {
    setState(() {
      _selectedSystem = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedSystem != null) {
      return LottoTipScreen(
        selectedSystem: _selectedSystem!,
        onBack: _handleBackToOverview,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_languageService.getTranslation('appTitle')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header mit aktuellen Jackpots
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🏆 Aktuelle Jackpots',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._systems.map((system) {
                      final jackpotData = JackpotService.getJackpotData(system.id);
                      final currentJackpot = jackpotData['currentJackpot'] ?? 'N/A';
                      final nextDraw = jackpotData['nextDraw'] as DateTime;
                      final countdown = JackpotService.getCountdown(nextDraw);
                      
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    currentJackpot,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  countdown,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'bis zur Ziehung',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Letzte Ziehungen
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📅 Letzte Ziehungen',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._systems.expand((system) {
                      final jackpotData = JackpotService.getJackpotData(system.id);
                      final lastDraws = List<Map<String, dynamic>>.from(jackpotData['lastDraws'] ?? []);
                      
                      return lastDraws.take(1).map((draw) {
                        final date = draw['date'] as DateTime;
                        final numbers = List<int>.from(draw['numbers'] ?? []);
                        final jackpotWon = draw['jackpotWon'] ?? false;
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
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
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    system.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    JackpotService.formatDate(date),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  if (jackpotWon) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Jackpot',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.green.shade800,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: numbers.map((number) {
                                  return Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: system.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        number.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        );
                      });
                    }).toList(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Schnellzugriff auf System-Auswahl
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎰 Schnellstart',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Wähle ein Lotto-System aus, um Tipps zu generieren:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _systems.map((system) {
                        return FilterChip(
                          label: Text(system.name),
                          backgroundColor: system.primaryColor,
                          selectedColor: system.primaryColor,
                          selected: false,
                          onSelected: (_) => _handleSystemSelected(system),
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }).toList(),
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
}
