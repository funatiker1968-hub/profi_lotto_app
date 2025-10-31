import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../services/lotto_system_service.dart';

class SystemSelectionScreen extends StatefulWidget {
  final Function(LottoSystem) onSystemSelected;
  final VoidCallback onBack;

  const SystemSelectionScreen({
    Key? key,
    required this.onSystemSelected,
    required this.onBack,
  }) : super(key: key);

  @override
  State<SystemSelectionScreen> createState() => _SystemSelectionScreenState();
}

class _SystemSelectionScreenState extends State<SystemSelectionScreen> {
  final LanguageService _languageService = LanguageService();

  @override
  Widget build(BuildContext context) {
    final availableSystems = LottoSystemService.getAvailableSystems();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_languageService.getTranslation('selectLottery')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _languageService.getTranslation('selectLotteryDesc'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: availableSystems.length,
                itemBuilder: (context, index) {
                  final system = availableSystems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: system.primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (index + 1).toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(system.name),
                      subtitle: Text(
                        '${system.maxNumbers} aus ${system.numberRange}${system.hasBonusNumbers ? ' + ${system.bonusNumbersCount} aus ${system.bonusNumberRange}' : ''}\n${system.description}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => widget.onSystemSelected(system),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
