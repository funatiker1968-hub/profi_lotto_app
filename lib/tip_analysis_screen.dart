import 'package:flutter/material.dart';
import 'services/app_state.dart';
import 'services/tip_analysis_service.dart';

class TipAnalysisScreen extends StatefulWidget {
  final AppState appState;
  final List<Map<String, dynamic>> tips;

  const TipAnalysisScreen({
    super.key,
    required this.appState,
    required this.tips,
  });

  @override
  State<TipAnalysisScreen> createState() => _TipAnalysisScreenState();
}

class _TipAnalysisScreenState extends State<TipAnalysisScreen> {
  final TipAnalysisService _analysisService = TipAnalysisService();
  late Map<String, dynamic> _analysis;

  @override
  void initState() {
    super.initState();
    _analysis = _analysisService.analyzeTips(widget.tips);
  }

  String _translate(String key) {
    switch (key) {
      case 'analysis': return 'Analyse';
      case 'totalTips': return 'Gesamte Tipps';
      case 'mostFrequent': return 'Häufigste Zahlen';
      case 'leastFrequent': return 'Seltenste Zahlen';
      case 'dateRange': return 'Zeitraum';
      case 'averageNumbers': return 'Ø Zahlen pro Tipp';
      case 'noAnalysis': return 'Keine Tipps zur Analyse';
      default: return key;
    }
  }

  Widget _buildNumberChip(int number, int frequency, Color color) {
    return Chip(
      backgroundColor: color.withOpacity(0.2),
      label: Text('$number ($frequency×)'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_translate('analysis')),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: _analysis['totalTips'] == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.analytics_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    _translate('noAnalysis'),
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Übersicht
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📊 Übersicht',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text('${_translate('totalTips')}: ${_analysis['totalTips']}'),
                          Text('${_translate('dateRange')}: ${_analysisService.formatDate(_analysis['dateRange']['start'])} - ${_analysisService.formatDate(_analysis['dateRange']['end'])}'),
                          Text('${_translate('averageNumbers')}: ${_analysis['averageNumbersPerTip'].toStringAsFixed(1)}'),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Häufigste Zahlen
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🔥 ${_translate('mostFrequent')}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (_analysis['mostFrequentNumbers'] as List<int>)
                                .map((number) => _buildNumberChip(
                                      number,
                                      _analysis['numberFrequency'][number] ?? 0,
                                      Colors.red,
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Seltenste Zahlen
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '❄️ ${_translate('leastFrequent')}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: (_analysis['leastFrequentNumbers'] as List<int>)
                                .map((number) => _buildNumberChip(
                                      number,
                                      _analysis['numberFrequency'][number] ?? 0,
                                      Colors.blue,
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Alle Zahlen-Häufigkeiten
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📈 Alle Zahlen',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: (_analysis['numberFrequency'] as Map<int, int>)
                                .entries
                                .map((entry) => Chip(
                                      label: Text('${entry.key}'),
                                      backgroundColor: Colors.grey[300],
                                    ))
                                .toList(),
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
