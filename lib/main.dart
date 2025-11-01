import 'package:flutter/material.dart';
import 'components/disclimber_wrapper.dart';
import 'services/language_service.dart';
import 'services/theme_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const LottoApp();
  }
}

class LottoApp extends StatefulWidget {
  const LottoApp({super.key});

  @override
  State<LottoApp> createState() => _LottoAppState();
}

class _LottoAppState extends State<LottoApp> {
  final LanguageService _languageService = LanguageService();
  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
    _themeService.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    _themeService.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _languageService.getTranslation('appTitle'),
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const DisclimberWrapper(),
    );
  }
}
