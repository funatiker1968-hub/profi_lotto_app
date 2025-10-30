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
    return widget.appState.translate(key);
  }

  Widget _buildNumberChip(int number, int frequency, Color color) {
    final isDarkMode = widget.appState.isDarkMode;
    return Chip(
      backgroundColor: isDarkMode ? color.withAlpha(77) : color.withAlpha(51),
      label: Text(
        '$number ($frequency×)',
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.appState,
      builder: (context, _, child) {
        final isDarkMode = widget.appState.isDarkMode;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(_translate('analysis')),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            actions: [
              // Sprachwechsel Button
              IconButton(
                icon: Text(widget.appState.getLanguageFlag(),
                    style: const TextStyle(fontSize: 20)),
                onPressed: widget.appState.switchLanguage,
                tooltip: widget.appState.getLanguageTooltip(),
              ),
              // Theme Switch
              IconButton(
                icon: Icon(widget.appState.isDarkMode 
                    ? Icons.light_mode : Icons.dark_mode),
                onPressed: widget.appState.toggleTheme,
                tooltip: widget.appState.isDarkMode
                    ? _translate('lightMode') : _translate('darkMode'),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: _buildAnalysisContent(isDarkMode),
        );
      },
    );
  }

  Widget _buildAnalysisContent(bool isDarkMode) {
    if (widget.tips.isEmpty) {
      return Center(
        child: Text(
          _translate('noAnalysis'),
          style: TextStyle(
            fontSize: 18,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistik Karten
            _buildStatCard(
              _translate('totalTips'),
              '${_analysis['totalTips']}',
              Icons.list,
              isDarkMode,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              _translate('dateRange'),
              '${_analysis['dateRange']['start']} - ${_analysis['dateRange']['end']}',
              Icons.calendar_today,
              isDarkMode,
            ),
            const SizedBox(height: 12),
            _buildStatCard(
              _translate('averageNumbers'),
              '${_analysis['averageNumbers']?.toStringAsFixed(1) ?? '0'}',
              Icons.calculate,
              isDarkMode,
            ),
            const SizedBox(height: 20),
            // Häufigste Zahlen
            _buildNumberSection(
              _translate('mostFrequent'),
              _analysis['mostFrequent'],
              Colors.green,
              isDarkMode,
            ),
            const SizedBox(height: 20),
            // Seltenste Zahlen
            _buildNumberSection(
              _translate('leastFrequent'),
              _analysis['leastFrequent'],
              Colors.red,
              isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, bool isDarkMode) {
    return Card(
      color: isDarkMode ? Colors.grey[800] : Colors.white,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: isDarkMode ? Colors.blue[200] : Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberSection(String title, List<dynamic> numbers, Color color, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: numbers.map<Widget>((item) {
            final number = item['number'] as int;
            final frequency = item['frequency'] as int;
            return _buildNumberChip(number, frequency, color);
          }).toList(),
        ),
      ],
    );
  }
}
