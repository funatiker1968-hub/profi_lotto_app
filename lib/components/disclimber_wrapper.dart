import 'package:flutter/material.dart';
import 'disclimber_dialog.dart';

class DisclimberWrapper extends StatefulWidget {
  final Widget child;
  
  const DisclimberWrapper({super.key, required this.child});

  @override
  State<DisclimberWrapper> createState() => _DisclimberWrapperState();
}

class _DisclimberWrapperState extends State<DisclimberWrapper> {
  bool _accepted = false;
  bool _showDialog = true;

  @override
  void initState() {
    super.initState();
    _showDisclimber();
  }

  Future<void> _showDisclimber() async {
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    
    final accepted = await DisclimberDialog.show(context);
    setState(() {
      _accepted = accepted;
      _showDialog = false;
    });
    
    if (!accepted) {
      // App einschränken - könnte hier navigieren oder Funktionen deaktivieren
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showDialog) {
      return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    return _accepted ? widget.child : _buildRestrictedView();
  }

  Widget _buildRestrictedView() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo Version - Eingeschränkt'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning, size: 64, color: Colors.orange),
            SizedBox(height: 20),
            Text('App-Funktionen eingeschränkt',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Demo Version - Bitte akzeptieren Sie die Nutzungsbedingungen'),
          ],
        ),
      ),
    );
  }
}
