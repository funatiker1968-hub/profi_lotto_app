import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../models/lotto_system.dart';

class SystemSelectionScreen extends StatefulWidget {
  final Function(LottoSystem) onSystemSelected;

  const SystemSelectionScreen({
    Key? key,
    required this.onSystemSelected,
  }) : super(key: key);

  @override
  State<SystemSelectionScreen> createState() => _SystemSelectionScreenState();
}

class _SystemSelectionScreenState extends State<SystemSelectionScreen> {
  final LanguageService _languageService = LanguageService();

  String _getSystemName(String systemKey) {
    final translations = {
      'lotto6aus49': 'Lotto 6aus49',
      'eurojackpot': 'Eurojackpot', 
      'sayisalLoto': 'Sayısal Loto',
      'sansTopu': 'Şans Topu',
    };
    return translations[systemKey] ?? systemKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_languageService.getTranslation('selectLottery')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                itemCount: LottoSystem.availableSystems.length,
                itemBuilder: (context, index) {
                  final system = LottoSystem.availableSystems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(_getSystemName(system.name)),
                      subtitle: Text(
                        '${system.mainNumbersCount} aus ${system.mainNumbersMax}${system.hasExtraNumbers ? ' + ${system.extraNumbersCount} aus ${system.extraNumbersMax}' : ''}',
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
