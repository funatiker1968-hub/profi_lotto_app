import 'package:flutter/material.dart';
import 'services/app_state.dart';

class TipAnalysisScreen extends StatelessWidget {
  final AppState appState;
  final List<Map<String, dynamic>> tips;

  const TipAnalysisScreen({
    super.key,
    required this.appState,
    required this.tips,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: appState,
      builder: (context, _, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(appState.translate('analysis')),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            actions: [
              IconButton(
                icon: Text(appState.getLanguageFlag(), 
                        style: const TextStyle(fontSize: 20)),
                onPressed: appState.switchLanguage,
                tooltip: appState.getLanguageTooltip(),
              ),
              IconButton(
                icon: Icon(appState.isDarkMode ? 
                          Icons.light_mode : Icons.dark_mode),
                onPressed: appState.toggleTheme,
                tooltip: appState.isDarkMode ? 
                         appState.translate('lightMode') : appState.translate('darkMode'),
              ),
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Center(
            child: Card(
              color: Theme.of(context).cardTheme.color,
              elevation: Theme.of(context).cardTheme.elevation,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.insights, size: 64, 
                         color: Theme.of(context).primaryColor),
                    const SizedBox(height: 16),
                    Text(
                      appState.translate('analysis'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tips: ${tips.length}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Language: ${appState.currentLanguage.toUpperCase()}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
