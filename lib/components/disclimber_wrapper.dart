import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/disclaimer_service.dart';
import '../services/app_state.dart';

class DisclimberWrapper extends StatefulWidget {
  final Widget child;
  final AppState appState;
  
  const DisclimberWrapper({super.key, required this.child, required this.appState});
  
  @override
  __DisclimberWrapperState createState() => __DisclimberWrapperState();
}

class __DisclimberWrapperState extends State<DisclimberWrapper> {
  final DisclaimerService _disclaimerService = DisclaimerService();
  bool _showDisclaimer = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkDisclaimerStatus();
  }

  Future<void> _checkDisclaimerStatus() async {
    final isAccepted = await _disclaimerService.isDisclaimerAccepted();
    setState(() {
      _showDisclaimer = !isAccepted;
      _isLoading = false;
    });
  }

  Future<void> _acceptDisclaimer() async {
    await _disclaimerService.setDisclaimerAccepted();
    setState(() {
      _showDisclaimer = false;
    });
  }

  void _declineDisclaimer() {
    // App schließen
    SystemNavigator.pop();
  }

  Widget _buildDisclaimerDialog() {
    final texts = DisclaimerService.getDisclaimerTexts(widget.appState.currentLanguage);
    
    return AlertDialog(
      title: Text(
        texts['title']!,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              texts['content']!,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 20),
            Text(
              texts['accept']!,
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _declineDisclaimer,
          child: Text(
            texts['decline']!,
            style: const TextStyle(color: Colors.red),
          ),
        ),
        ElevatedButton(
          onPressed: _acceptDisclaimer,
          child: Text(texts['continue']!),
        ),
      ],
      scrollable: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_showDisclaimer) {
      return ValueListenableBuilder<bool>(
        valueListenable: widget.appState,
        builder: (context, _, child) {
          return Scaffold(
            backgroundColor: Colors.grey[900],
            body: Center(
              child: _buildDisclaimerDialog(),
            ),
          );
        },
      );
    }

    return widget.child;
  }
}
