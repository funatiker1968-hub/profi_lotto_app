with open('lib/components/lotto_tip_screen.dart', 'r') as f:
    content = f.read()

# Korrigiere die _generateNewTip Methode
old_method = '''void _generateNewTip() async {
    await _storageService.init();

    setState(() {
      _currentTip = _lottoService.generateTipForSystem(widget.selectedSystem);
      _currentBonusNumbers = widget.selectedSystem.hasBonusNumbers
          ? LottoSystemService.generateBonusNumbers(widget.selectedSystem)
          : [];
    });

    // Tipp speichern
    final allNumbers = [..._currentTip, ..._currentBonusNumbers];
    await _storageService.saveTip(allNumbers, widget.selectedSystem);

    // Historie aktualisieren
    final updatedTips = _storageService.getTipsBySystem(widget.selectedSystem.id);
    setState(() {
      _tipHistory = updatedTips;
    });
  }'''

new_method = '''void _generateNewTip() async {
    await _storageService.init();

    setState(() {
      _currentTip = _lottoService.generateTipForSystem(widget.selectedSystem);
    });

    // Tipp speichern - Haupt- und Bonus-Zahlen getrennt
    final allNumbers = [
      ..._currentTip['mainNumbers'] ?? [],
      ..._currentTip['bonusNumbers'] ?? []
    ];
    await _storageService.saveTip(allNumbers, widget.selectedSystem);

    // Historie aktualisieren
    final updatedTips = _storageService.getTipsBySystem(widget.selectedSystem.id);
    setState(() {
      _tipHistory = updatedTips;
    });
  }'''

content = content.replace(old_method, new_method)

with open('lib/components/lotto_tip_screen.dart', 'w') as f:
    f.write(content)

print("✅ _generateNewTip Methode korrigiert")
