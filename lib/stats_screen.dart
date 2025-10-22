import 'package:flutter/material.dart';
import 'lotto_service.dart';

class StatsScreen extends StatelessWidget {
  final List<List<int>> allTips;
  
  const StatsScreen({super.key, required this.allTips});
  
  @override
  Widget build(BuildContext context) {
    final frequency = LottoService.calculateNumberFrequency(allTips);
    final hotNumbers = LottoService.getHotNumbers(frequency);
    final coldNumbers = LottoService.getColdNumbers(frequency);
    final averageFreq = LottoService.calculateAverageFrequency(frequency, allTips.length);
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          '📊 STATISTIK',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2D2D2D),
        elevation: 8,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Übersichtskarte
            _buildStatsCard(
              '📈 ÜBERSICHT',
              Column(
                children: [
                  _buildStatRow('Gesamte Tipps:', '${allTips.length}'),
                  _buildStatRow('Verwendete Zahlen:', '${frequency.length}/49'),
                  _buildStatRow('Durchschn. Häufigkeit:', '${averageFreq.toStringAsFixed(2)}'),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Heiße Zahlen
            _buildStatsCard(
              '🔥 HEISSE ZAHLEN',
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: hotNumbers.map((number) => _buildNumberChip(
                  number, 
                  Colors.red[700]!, 
                  frequency[number] ?? 0,
                )).toList(),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Kalte Zahlen  
            _buildStatsCard(
              '❄️ KALTE ZAHLEN',
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: coldNumbers.map((number) => _buildNumberChip(
                  number,
                  Colors.blue[700]!,
                  frequency[number] ?? 0,
                )).toList(),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Vollständige Häufigkeitstabelle
            _buildStatsCard(
              '📋 VOLLSTÄNDIGE HÄUFIGKEIT',
              Column(
                children: _buildFrequencyTable(frequency),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatsCard(String title, Widget content) {
    return Card(
      elevation: 6,
      color: const Color(0xFF2D2D2D),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFFFD700), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNumberChip(int number, Color color, int frequency) {
    return Chip(
      backgroundColor: color.withOpacity(0.2),
      label: Text(
        '${number.toString().padLeft(2, '0')} ($frequency)',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
      side: BorderSide(color: color),
    );
  }
  
  List<Widget> _buildFrequencyTable(Map<int, int> frequency) {
    final sortedNumbers = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedNumbers.map((entry) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Zahl ${entry.key.toString().padLeft(2, '0')}:',
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            '${entry.value}x',
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    )).toList();
  }
}
