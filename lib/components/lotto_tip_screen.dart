import 'package:flutter/material.dart';
import '../models/lotto_system.dart';

class LottoTipScreen extends StatefulWidget {
  final LottoSystem selectedSystem;

  const LottoTipScreen({
    super.key,
    required this.selectedSystem,
  });

  @override
  State<LottoTipScreen> createState() => _LottoTipScreenState();
}

class _LottoTipScreenState extends State<LottoTipScreen> {
  
  @override
  void initState() {
    super.initState();
    print('LottoTipScreen geladen für: ${widget.selectedSystem.displayName}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedSystem.displayName),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lotto System: ${widget.selectedSystem.displayName}',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  '${widget.selectedSystem.mainNumbersCount} aus ${widget.selectedSystem.mainNumbersMax}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (widget.selectedSystem.hasExtraNumbers) ...[
                  const SizedBox(height: 10),
                  Text(
                    '+ ${widget.selectedSystem.extraNumbersCount} aus ${widget.selectedSystem.extraNumbersMax}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
                const SizedBox(height: 40),
                const Text(
                  'Tipp-Generierung kommt in Version 3.1...',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Zurück zur System-Auswahl
                    Navigator.of(context).pop();
                  },
                  child: const Text('Zurück zur Auswahl'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
