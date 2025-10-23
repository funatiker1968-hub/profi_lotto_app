import 'package:flutter/material.dart';
import 'services/app_state.dart';
import 'services/jackpot_preferences.dart';

class JackpotSettingsScreen extends StatefulWidget {
  final AppState appState;

  const JackpotSettingsScreen({super.key, required this.appState});

  @override
  State<JackpotSettingsScreen> createState() => _JackpotSettingsScreenState();
}

class _JackpotSettingsScreenState extends State<JackpotSettingsScreen> {
  final JackpotPreferences _prefs = JackpotPreferences();
  late bool _notificationsEnabled;
  late int _threshold;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _notificationsEnabled = await _prefs.getNotificationsEnabled();
    _threshold = await _prefs.getThreshold();
    setState(() {});
  }

  String _translate(String key) {
    switch (key) {
      case 'jackpotSettings':
        return widget.appState.currentLanguage == 'de' 
            ? 'Jackpot Benachrichtigungen'
            : widget.appState.currentLanguage == 'tr'
              ? 'Jackpot Bildirimleri'
              : 'Jackpot Notifications';
      case 'enableNotifications':
        return widget.appState.currentLanguage == 'de' 
            ? 'Benachrichtigungen aktivieren'
            : widget.appState.currentLanguage == 'tr'
              ? 'Bildirimleri etkinleştir'
              : 'Enable notifications';
      case 'threshold':
        return widget.appState.currentLanguage == 'de' 
            ? 'Jackpot Schwellenwert'
            : widget.appState.currentLanguage == 'tr'
              ? 'Jackpot Eşik Değeri'
              : 'Jackpot threshold';
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_translate('jackpotSettings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text(_translate('enableNotifications')),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() => _notificationsEnabled = value);
              _prefs.setNotificationsEnabled(value);
            },
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _translate('threshold'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Aktuell: ${_formatAmount(_threshold)} €'),
                  Slider(
                    value: _threshold.toDouble(),
                    min: 1000000,
                    max: 100000000,
                    divisions: 99,
                    label: _formatAmount(_threshold),
                    onChanged: (value) {
                      setState(() => _threshold = value.toInt());
                      _prefs.setThreshold(value.toInt());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(0)}M';
    }
    return amount.toString();
  }
}
