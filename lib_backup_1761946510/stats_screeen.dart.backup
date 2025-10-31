import 'package:flutter/material.dart';
import 'services/app_state.dart';

class StatsScreen extends StatelessWidget {
  final AppState appState;

  const StatsScreen({super.key, required this.appState});

  // Beispiel-Daten für heiße und kalte Zahlen
  Map<String, dynamic> _getNumberStats() {
    return {
      'hotNumbers': [
        {'number': 7, 'frequency': 45},
        {'number': 23, 'frequency': 42},
        {'number': 12, 'frequency': 39},
        {'number': 31, 'frequency': 38},
        {'number': 44, 'frequency': 37},
      ],
      'coldNumbers': [
        {'number': 1, 'frequency': 12},
        {'number': 49, 'frequency': 14},
        {'number': 8, 'frequency': 15},
        {'number': 13, 'frequency': 16},
        {'number': 40, 'frequency': 17},
      ],
    };
  }

  String _getHotNumbersExplanation(String language) {
    switch (language) {
      case 'de':
        return 'Heiße Zahlen werden häufig gezogen. Sie haben eine höhere Wahrscheinlichkeit, in zukünftigen Ziehungen aufzutauchen.';
      case 'en':
        return 'Hot numbers are drawn frequently. They have a higher probability of appearing in future draws.';
      case 'tr':
        return 'Sıcak numaralar sıkça çekilir. Gelecek çekilişlerde görünme olasılıkları daha yüksektir.';
      default:
        return 'Hot numbers are drawn frequently.';
    }
  }

  String _getColdNumbersExplanation(String language) {
    switch (language) {
      case 'de':
        return 'Kalte Zahlen werden selten gezogen. Einige Spieler glauben, dass sie "überfällig" sind und bald gezogen werden.';
      case 'en':
        return 'Cold numbers are drawn rarely. Some players believe they are "overdue" and will be drawn soon.';
      case 'tr':
        return 'Soğuk numaralar nadiren çekilir. Bazı oyuncular "gecikmiş" olduklarına ve yakında çekileceklerine inanır.';
      default:
        return 'Cold numbers are drawn rarely.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = _getNumberStats();
    
    return ValueListenableBuilder<bool>(
      valueListenable: appState,
      builder: (context, _, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(appState.translate('stats')),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            actions: [
              IconButton(
                icon: Text(appState.getLanguageFlag(), 
                        style: const TextStyle(fontSize: 20)),
                onPressed: appState.switchLanguage,
                tooltip: appState.getLanguageTooltip(),
              ),
              IconButton(
                icon: Icon(appState.isDarkMode ? 
                          Icons.light_mode : Icons.dark_mode),
                onPressed: appState.toggleTheme,
                tooltip: appState.isDarkMode ? 
                         appState.translate('lightMode') : appState.translate('darkMode'),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Heiße Zahlen
                Card(
                  color: Theme.of(context).cardTheme.color,
                  elevation: Theme.of(context).cardTheme.elevation,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.whatshot, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              appState.currentLanguage == 'de' 
                                ? 'Heiße Zahlen' 
                                : appState.currentLanguage == 'tr'
                                  ? 'Sıcak Numaralar'
                                  : 'Hot Numbers',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getHotNumbersExplanation(appState.currentLanguage),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: stats['hotNumbers'].map<Widget>((numData) {
                            return Chip(
                              backgroundColor: Colors.red.withOpacity(0.2),
                              label: Text(
                                '${numData['number']} (${numData['frequency']}x)',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Kalte Zahlen
                Card(
                  color: Theme.of(context).cardTheme.color,
                  elevation: Theme.of(context).cardTheme.elevation,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.ac_unit, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              appState.currentLanguage == 'de' 
                                ? 'Kalte Zahlen' 
                                : appState.currentLanguage == 'tr'
                                  ? 'Soğuk Numaralar'
                                  : 'Cold Numbers',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getColdNumbersExplanation(appState.currentLanguage),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: stats['coldNumbers'].map<Widget>((numData) {
                            return Chip(
                              backgroundColor: Colors.blue.withOpacity(0.2),
                              label: Text(
                                '${numData['number']} (${numData['frequency']}x)',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Erklärung
                Card(
                  color: Theme.of(context).cardTheme.color,
                  elevation: Theme.of(context).cardTheme.elevation,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appState.currentLanguage == 'de' 
                            ? 'Wie funktionieren heiße und kalte Zahlen?' 
                            : appState.currentLanguage == 'tr'
                              ? 'Sıcak ve Soğuk Numaralar Nasıl Çalışır?'
                              : 'How do Hot and Cold Numbers work?',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          appState.currentLanguage == 'de' 
                            ? '• Heiße Zahlen: Werden häufig gezogen (basierend auf historischen Daten)\n'
                              '• Kalte Zahlen: Werden selten gezogen, könnten "überfällig" sein\n'
                              '• Tippstrategie: Kombinieren Sie beide für ausgewogene Tipps'
                            : appState.currentLanguage == 'tr'
                              ? '• Sıcak numaralar: Tarihsel verilere göre sık çekilir\n'
                                '• Soğuk numaralar: Nadiren çekilir, "gecikmiş" olabilir\n'
                                '• Tipik strateji: Dengeli tahminler için her ikisini de birleştirin'
                              : '• Hot numbers: Drawn frequently based on historical data\n'
                                '• Cold numbers: Drawn rarely, might be "overdue"\n'
                                '• Tip strategy: Combine both for balanced tips',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
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
