import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Information'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Entwickler Information',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    const Text('Initiator: Yalçın Kaya'),
                    const Text('© Alle Rechte vorbehalten'),
                    const SizedBox(height: 15),
                    const Text('Gefällt dir die App?'),
                    const Text('Unterstütze die Weiterentwicklung:'),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        // PayPal Spenden-Link würde hier hin
                        _showDonationInfo(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.attach_money, color: Colors.green),
                            SizedBox(width: 8),
                            Text('PayPal Spende',
                                style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Demo Version Hinweis',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('• Keine Gewährleistung auf angezeigte Zahlen'),
                    Text('• Diese App ist eine Demo-Version'),
                    Text('• Nur zu Unterhaltungszwecken'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Zurück zur App'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDonationInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Spendeninformation'),
        content: const Text('PayPal Spende: comming soon...\n\nVielen Dank für Ihre Unterstützung!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
