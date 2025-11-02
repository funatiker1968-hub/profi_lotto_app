import 'package:shared_preferences/shared_preferences.dart';
import 'lotto_system_service.dart';
import 'dart:convert';

class StorageService {
  static const String _tipsKey = 'lotto_tips';
  List<Map<String, dynamic>> _tips = [];

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final tipsJson = prefs.getString(_tipsKey);

    if (tipsJson != null) {
      try {
        final List<dynamic> tipsList = json.decode(tipsJson);
        _tips = tipsList.cast<Map<String, dynamic>>();
      } catch (e) {
        _tips = [];
      }
    } else {
      _tips = [];
    }
  }

  List<Map<String, dynamic>> getTips() {
    return List.from(_tips);
  }

  List<Map<String, dynamic>> getTipsBySystem(String systemId) {
    return _tips.where((tip) => tip['system'] == systemId).toList();
  }

  Future<String> saveTip(List<int> numbers, LottoSystem system) async {
    final tipId = DateTime.now().millisecondsSinceEpoch.toString();
    
    final tip = {
      'id': tipId,
      'numbers': numbers,
      'system': system.id,
      'createdAt': DateTime.now().toIso8601String(),
      'winInfo': {
        'isWinner': false,
        'winAmount': 0.0,
        'winTier': 0,
        'matchedNumbers': 0,
        'matchedBonusNumbers': 0,
      },
    };

    _tips.add(tip);
    await _saveToStorage();
    return tipId;
  }

  Future<void> updateTipWinInfo(String tipId, Map<String, dynamic> winInfo) async {
    final tipIndex = _tips.indexWhere((tip) => tip['id'] == tipId);
    if (tipIndex != -1) {
      _tips[tipIndex]['winInfo'] = winInfo;
      await _saveToStorage();
    }
  }

  Future<void> deleteTip(String tipId) async {
    _tips.removeWhere((tip) => tip['id'] == tipId);
    await _saveToStorage();
  }

  Future<void> clearTipsBySystem(String systemId) async {
    _tips.removeWhere((tip) => tip['system'] == systemId);
    await _saveToStorage();
  }

  Future<void> clearAllTips() async {
    _tips.clear();
    await _saveToStorage();
  }

  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tipsKey, json.encode(_tips));
  }

  // Statistik-Methoden
  int getTotalTipsCount() {
    return _tips.length;
  }

  int getSystemTipsCount(String systemId) {
    return _tips.where((tip) => tip['system'] == systemId).length;
  }

  double getTotalWins() {
    return _tips.fold(0.0, (sum, tip) {
      final winInfo = tip['winInfo'] as Map<String, dynamic>?;
      return sum + (winInfo?['winAmount'] ?? 0.0);
    });
  }

  int getWinCount() {
    return _tips.where((tip) {
      final winInfo = tip['winInfo'] as Map<String, dynamic>?;
      return winInfo?['isWinner'] == true;
    }).length;
  }
}
