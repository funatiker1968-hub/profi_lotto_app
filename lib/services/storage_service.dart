import 'package:shared_preferences/shared_preferences.dart';
import 'lotto_system_service.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Tipp speichern
  Future<void> saveTip(List<int> tip, LottoSystem system) async {
    final timestamp = DateTime.now().toIso8601String();
    final tipData = {
      'numbers': tip,
      'system': system.id,
      'timestamp': timestamp,
    };
    
    final existingTips = getTips();
    existingTips.add(tipData);
    
    // Konvertiere zu JSON-String Liste für SharedPreferences
    final tipStrings = existingTips.map((tip) => 
      '${tip['timestamp']}|${tip['system']}|${tip['numbers']?.join(',')}'
    ).toList();
    
    await _prefs?.setStringList('saved_tips', tipStrings);
  }

  // Alle Tipps laden
  List<Map<String, dynamic>> getTips() {
    final tipStrings = _prefs?.getStringList('saved_tips') ?? [];
    final tips = <Map<String, dynamic>>[];
    
    for (final tipString in tipStrings) {
      final parts = tipString.split('|');
      if (parts.length == 3) {
        final numbers = parts[2].split(',').map((n) => int.tryParse(n) ?? 0).toList();
        tips.add({
          'timestamp': parts[0],
          'system': parts[1],
          'numbers': numbers,
        });
      }
    }
    
    return tips;
  }

  // Tipps nach System filtern
  List<Map<String, dynamic>> getTipsBySystem(String systemId) {
    return getTips().where((tip) => tip['system'] == systemId).toList();
  }

  // Bestimmten Tipp löschen
  Future<void> deleteTip(int index) async {
    final tips = getTips();
    if (index >= 0 && index < tips.length) {
      tips.removeAt(index);
      final tipStrings = tips.map((tip) => 
        '${tip['timestamp']}|${tip['system']}|${tip['numbers']?.join(',')}'
      ).toList();
      await _prefs?.setStringList('saved_tips', tipStrings);
    }
  }

  // Alle Tipps löschen
  Future<void> clearAllTips() async {
    await _prefs?.remove('saved_tips');
  }

  // Tipp-Statistik
  Map<String, dynamic> getTipStatistics() {
    final tips = getTips();
    final totalTips = tips.length;
    
    // Zähle Tipps pro System
    final systemCount = <String, int>{};
    for (final tip in tips) {
      final system = tip['system'] as String;
      systemCount[system] = (systemCount[system] ?? 0) + 1;
    }
    
    // Finde letzte Tipp-Zeit
    final lastTipTime = tips.isNotEmpty 
        ? tips.last['timestamp'] as String 
        : 'Keine Tipps';
    
    return {
      'totalTips': totalTips,
      'systemCount': systemCount,
      'lastTipTime': lastTipTime,
    };
  }

  // Einstellungen speichern
  Future<void> saveSetting(String key, dynamic value) async {
    if (value is String) {
      await _prefs?.setString(key, value);
    } else if (value is int) {
      await _prefs?.setInt(key, value);
    } else if (value is bool) {
      await _prefs?.setBool(key, value);
    } else if (value is double) {
      await _prefs?.setDouble(key, value);
    }
  }

  // Einstellungen laden
  dynamic getSetting(String key, [dynamic defaultValue]) {
    return _prefs?.get(key) ?? defaultValue;
  }
}
