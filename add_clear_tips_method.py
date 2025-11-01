with open('lib/services/storage_service.dart', 'r') as f:
    content = f.read()

# Prüfe ob clearTipsBySystem bereits existiert
if 'clearTipsBySystem' not in content:
    # Füge die Methode nach getTipsBySystem ein
    insert_point = content.find('List<Map<String, dynamic>> getTipsBySystem(String systemId)')
    if insert_point != -1:
        # Finde das Ende der getTipsBySystem Methode
        method_end = content.find('}', content.find('{', insert_point))
        if method_end != -1:
            # Füge clearTipsBySystem Methode ein
            new_method = '''
  
  Future<void> clearTipsBySystem(String systemId) async {
    await init();
    final allTips = _getAllTips();
    final filteredTips = allTips.where((tip) => tip['system'] != systemId).toList();
    await _storage.setStringList('lotto_tips', 
        filteredTips.map((tip) => jsonEncode(tip)).toList());
  }'''
            
            content = content[:method_end + 1] + new_method + content[method_end + 1:]
            print("✅ clearTipsBySystem Methode hinzugefügt")
    else:
        print("❌ Einfügepunkt nicht gefunden")
else:
    print("ℹ️ clearTipsBySystem bereits vorhanden")

with open('lib/services/storage_service.dart', 'w') as f:
    f.write(content)
