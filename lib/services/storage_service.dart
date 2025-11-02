import 'package:shared_preferences/shared_preferences.dart';
import 'lotto_system_service.dart';

class StorageService {
  static const String _tipsKey = 'lotto_tips';
  List<Map<String, dynamic>> _tips = [];

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final tipsJson = prefs.getString(_tipsKey);
    
    if (tipsJson != null) {
      try {
        // JSON parsing würde hier implementiert werden
        // Für jetzt simulieren wir leere Daten
        _tips = [];
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

  Future<void> saveTip(List<int> numbers, LottoSystem system) async {
    final tip = {
      'numbers': numbers,
      'system': system.id,
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    _tips.add(tip);
    await _saveToStorage();
  }

  Future<void> deleteTip(int index) async {
    if (index >= 0 && index < _tips.length) {
      _tips.removeAt(index);
      await _saveToStorage();
    }
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
    // Hier würde JSON serialization implementiert werden
    // Für jetzt speichern wir einfach eine leere Liste
    await prefs.setString(_tipsKey, '[]');
  }
}
