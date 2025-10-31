import 'package:flutter/material.dart';
import '../models/lotto_system.dart';
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

  @override
  Widget build(BuildContext context) {
    if (!_disclaimerAccepted) {
      return _buildDisclaimerScreen();
    }

    if (_selectedSystem == null) {
      return SystemSelectionScreen(onSystemSelected: _handleSystemSelected);
    }

    return LottoTipScreen(selectedSystem: _selectedSystem!);
  }

  Widget _buildDisclaimerScreen() {
    return Scaffold(
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
                      onPressed: () {},
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
