import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SmartLottoApp());
}

class SmartLottoApp extends StatefulWidget {
  @override
  State<SmartLottoApp> createState() => _SmartLottoAppState();
}

class _SmartLottoAppState extends State<SmartLottoApp> {
  ThemeMode _mode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Lotto Generator',
      themeMode: _mode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Lotto Generator (Profi)'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (val) {
                setState(() {
                  if (val == 'light') _mode = ThemeMode.light;
                  if (val == 'dark') _mode = ThemeMode.dark;
                  if (val == 'system') _mode = ThemeMode.system;
                });
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'light', child: Text('Hell')),
                PopupMenuItem(value: 'dark', child: Text('Dunkel')),
                PopupMenuItem(value: 'system', child: Text('System')),
              ],
            ),
          ],
        ),
        body: const Center(
          child: Text(
            'Smart Lotto Generator Profi (Demo)\n\nCloud Sync vorbereitet.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
