import 'package:shared_preferences/shared_preferences.dart';

class JackpotPreferences {
  static const String _notificationsEnabledKey = 'jackpot_notifications_enabled';
  static const String _thresholdKey = 'jackpot_threshold';
  static const String _gamesKey = 'selected_games';

  // Benachrichtigungen ein/aus
  Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }

  // Jackpot Schwellenwert
  Future<int> getThreshold() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_thresholdKey) ?? 10000000; // 10 Millionen Default
  }

  Future<void> setThreshold(int threshold) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_thresholdKey, threshold);
  }

  // Ausgewählte Spiele
  Future<List<String>> getSelectedGames() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_gamesKey) ?? ['lotto6aus49', 'eurojackpot'];
  }

  Future<void> setSelectedGames(List<String> games) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_gamesKey, games);
  }
}
