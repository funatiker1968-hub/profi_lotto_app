import 'package:flutter/material.dart';
import 'lotto_service.dart';

class TipAnalysisScreen extends StatefulWidget {
  final List<List<int>> allTips;
  
  const TipAnalysisScreen({super.key, required this.allTips});
  
  @override
  State<TipAnalysisScreen> createState() => _TipAnalysisScreenState();
}

class _TipAnalysisScreenState extends State<TipAnalysisScreen> {
  int _selectedTipIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    if (widget.allTips.isEmpty) {
      return _buildEmptyState();
    }
    
    final currentTip = widget.allTips[_selectedTipIndex];
    final analysis = LottoService.analyzeTipPattern(currentTip);
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          '🔍 TIPP ANALYSE',
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
        child: Column(
          children: [
            // Tipp Auswahl
            _buildTipSelector(),
            
            const SizedBox(height: 20),
            
            // Aktueller Tipp Anzeige
            _buildCurrentTipCard(currentTip),
            
            const SizedBox(height: 20),
            
            // Analyse Ergebnisse
            Expanded(
              child: ListView(
                children: [
                  _buildAnalysisCard('📐 MUSTER-ANALYSE', [
                    _buildAnalysisRow('Aufeinanderfolgende Zahlen:', 
                        analysis['hasConsecutive'] ? '✅ Ja' : '❌ Nein'),
                    _buildAnalysisRow('Tiefe/Zahlen Verhältnis:', 
                        '${analysis['lowHighRatio'].toStringAsFixed(2)}'),
                    _buildAnalysisRow('Gerade/Ungerade Verhältnis:', 
                        '${analysis['evenOddRatio'].toStringAsFixed(2)}'),
                    _buildAnalysisRow('Durchschn. Zahlenabstand:', 
                        '${analysis['averageGap'].toStringAsFixed(1)}'),
                    _buildAnalysisRow('Max. Zahlenabstand:', 
                        '${analysis['maxGap'].toString()}'),
                  ]),
                  
                  const SizedBox(height: 20),
                  
                  // Qualitäts-Bewertung
                  _buildQualityRating(analysis),
                  
                  const SizedBox(height: 20),
                  
                  // Verbesserungsvorschläge
                  _buildImprovementSuggestions(analysis, currentTip),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          '🔍 TIPP ANALYSE',
          style: TextStyle(
            color: Color(0xFFFFD700),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF2D2D2D),
        elevation: 8,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Keine Tipps zur Analyse',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Generiere zuerst einige Tipps!',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTipSelector() {
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
            const Text(
              '🎯 TIPP AUSWÄHLEN',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButton<int>(
              value: _selectedTipIndex,
              dropdownColor: const Color(0xFF2D2D2D),
              style: const TextStyle(color: Colors.white),
              onChanged: (newIndex) {
                setState(() {
                  _selectedTipIndex = newIndex!;
                });
              },
              items: List.generate(widget.allTips.length, (index) {
                final tip = widget.allTips[index];
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(
                    'Tipp ${index + 1}: ${tip.join(' - ')}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCurrentTipCard(List<int> tip) {
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
          children: [
            const Text(
              '📋 AKTUELLER TIPP',
              style: TextStyle(
                color: Color(0xFFFFD700),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: tip.map((number) => _buildAnalysisBall(number)).toList(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAnalysisBall(int number) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: const RadialGradient(
          colors: [Colors.white, Color(0xFFFFD700)],
          stops: [0.1, 1.0],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB8860B), width: 2),
      ),
      child: Center(
        child: Text(
          number.toString().padLeft(2, '0'),
          style: const TextStyle(
            color: Color(0xFF8B4513),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  
  Widget _buildAnalysisCard(String title, List<Widget> content) {
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
            ...content,
          ],
        ),
      ),
    );
  }
  
  Widget _buildAnalysisRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQualityRating(Map<String, dynamic> analysis) {
    final score = _calculateQualityScore(analysis);
    Color ratingColor;
    String ratingText;
    
    if (score >= 80) {
      ratingColor = Colors.green;
      ratingText = 'AUSGEZEICHNET';
    } else if (score >= 60) {
      ratingColor = Colors.orange;
      ratingText = 'GUT';
    } else {
      ratingColor = Colors.red;
      ratingText = 'VERBESSERUNGSFÄHIG';
    }
    
    return _buildAnalysisCard('⭐ QUALITÄTSBEWERTUNG', [
      Center(
        child: Column(
          children: [
            Text(
              '$score/100',
              style: TextStyle(
                color: ratingColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ratingText,
              style: TextStyle(
                color: ratingColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
  
  int _calculateQualityScore(Map<String, dynamic> analysis) {
    int score = 100;
    
    // Punkte abziehen für schlechte Muster
    if (analysis['hasConsecutive'] == true) score -= 15;
    if (analysis['lowHighRatio'] < 0.5 || analysis['lowHighRatio'] > 2.0) score -= 20;
    if (analysis['evenOddRatio'] < 0.5 || analysis['evenOddRatio'] > 2.0) score -= 20;
    if (analysis['averageGap'] > 10) score -= 15;
    if (analysis['maxGap'] > 15) score -= 10;
    
    return score.clamp(0, 100);
  }
  
  Widget _buildImprovementSuggestions(Map<String, dynamic> analysis, List<int> tip) {
    final suggestions = <String>[];
    
    if (analysis['hasConsecutive'] == true) {
      suggestions.add('Vermeide aufeinanderfolgende Zahlen');
    }
    
    if (analysis['lowHighRatio'] < 0.5) {
      suggestions.add('Füge mehr tiefe Zahlen (1-25) hinzu');
    } else if (analysis['lowHighRatio'] > 2.0) {
      suggestions.add('Füge mehr hohe Zahlen (26-49) hinzu');
    }
    
    if (analysis['evenOddRatio'] < 0.5) {
      suggestions.add('Mehr gerade Zahlen verwenden');
    } else if (analysis['evenOddRatio'] > 2.0) {
      suggestions.add('Mehr ungerade Zahlen verwenden');
    }
    
    if (analysis['averageGap'] > 10) {
      suggestions.add('Zahlen sollten näher beieinander liegen');
    }
    
    if (suggestions.isEmpty) {
      suggestions.add('Tipp hat eine gute Verteilung! 👍');
    }
    
    return _buildAnalysisCard('💡 VERBESSERUNGSVORSCHLÄGE', [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: suggestions.map((suggestion) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: Color(0xFFFFD700), size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  suggestion,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    ]);
  }
}
