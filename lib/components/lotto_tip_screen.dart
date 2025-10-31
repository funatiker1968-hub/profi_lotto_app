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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.selectedSystem.displayName),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Lotto System: ${widget.selectedSystem.displayName}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              '${widget.selectedSystem.mainNumbersCount} aus ${widget.selectedSystem.mainNumbersMax}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (widget.selectedSystem.hasExtraNumbers) 
              Text(
                '+ ${widget.selectedSystem.extraNumbersCount} aus ${widget.selectedSystem.extraNumbersMax}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
          ],
        ),
      ),
    );
  }
}
