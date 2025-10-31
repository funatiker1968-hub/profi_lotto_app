import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../services/lotto_system_service.dart';
import '../services/jackpot_service.dart';

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
                  final jackpotData = JackpotService.getJackpotData(system.id);
                  final currentJackpot = jackpotData['currentJackpot'] ?? 'N/A';
                  final nextDraw = jackpotData['nextDraw'] as DateTime;
                  final countdown = JackpotService.getCountdown(nextDraw);
                  
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        width: 50,
                        height: 50,
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
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            system.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Jackpot: $currentJackpot',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            '${system.mainNumbersCount} aus ${system.mainNumbersMax}${system.hasBonusNumbers ? ' + ${system.bonusNumbersCount} aus ${system.bonusNumbersMax}' : ''}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            system.description,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Nächste Ziehung: $countdown',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade800,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
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
