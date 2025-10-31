import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Tipps speichern
  Future<void> saveTips(List<String> tips) async {
    await _prefs?.setStringList('saved_tips', tips);
  }

  // Tipps laden
  List<String> getTips() {
    return _prefs?.getStringList('saved_tips') ?? [];
  }

  // Statistik speichern
  Future<void> saveStats(Map<String, dynamic> stats) async {
    // Implementierung für Statistik-Speicherung
  }

  // Einstellungen speichern
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    // Implementierung für Einstellungen
  }
}
