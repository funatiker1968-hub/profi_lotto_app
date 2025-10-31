import 'package:flutter/material.dart';
import '../services/lotto_system_service.dart';
import 'system_selection_screen.dart';
import 'lotto_tip_screen.dart';

class DisclimberWrapper extends StatefulWidget {
  const DisclimberWrapper({super.key});

  @override
  State<DisclimberWrapper> createState() => _DisclimberWrapperState();
}

class _DisclimberWrapperState extends State<DisclimberWrapper> {
  bool _disclaimerAccepted = false;
  LottoSystem? _selectedSystem;

  void _handleDisclaimerAccept() {
    setState(() {
      _disclaimerAccepted = true;
    });
  }

  void _handleSystemSelected(LottoSystem system) {
    setState(() {
      _selectedSystem = system;
    });
  }

  void _handleBackToSystemSelection() {
    setState(() {
      _selectedSystem = null;
    });
  }

  void _handleBackToDisclaimer() {
    setState(() {
      _selectedSystem = null;
      _disclaimerAccepted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_disclaimerAccepted) {
      return _buildDisclaimerScreen();
    }

    if (_selectedSystem == null) {
      return SystemSelectionScreen(
        onSystemSelected: _handleSystemSelected,
        onBack: _handleBackToDisclaimer,
      );
    }

    return LottoTipScreen(
      selectedSystem: _selectedSystem!,
      onBack: _handleBackToSystemSelection,
    );
  }

  Widget _buildDisclaimerScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lotto World Pro'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber, size: 64, color: Colors.orange),
              const SizedBox(height: 24),
              const Text(
                'Haftungsausschluss',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Diese App dient nur zu Unterhaltungszwecken. Glücksspiel kann süchtig machen.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // App schließen bei Ablehnung
                        Navigator.of(context).pop();
                      },
                      child: const Text('Ablehnen'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleDisclaimerAccept,
                      child: const Text('Akzeptieren'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
