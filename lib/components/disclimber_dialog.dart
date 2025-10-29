import 'package:flutter/material.dart';

class DisclimberDialog {
  static Future<bool> show(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 10),
              Text('Wichtiger Hinweis'),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('DEMO-VERSION - KEINE GEWÄHRLEISTUNG',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('Diese App ist eine Demo-Version.'),
                Text('Die angezeigten Zahlen sind keine echten Gewinnzahlen.'),
                Text('Keine Garantie auf Richtigkeit oder Gewinnchancen.'),
                SizedBox(height: 15),
                Text('Möchten Sie die App weiterhin nutzen?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('NEIN - Verlassen'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              child: Text('JA - Fortsetzen'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }
}
