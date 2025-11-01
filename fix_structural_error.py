with open('lib/components/jackpot_overview_screen.dart', 'r') as f:
    lines = f.readlines()

# Entferne die überflüssigen schließenden Klammern in Zeilen 194-198
# Behalte nur die notwendigen Klammern bei
new_lines = []
skip_count = 0

for i, line in enumerate(lines, 1):
    if i >= 194 and i <= 198:
        if '],' in line or '),' in line:
            if skip_count < 3:  # Behalte die ersten 3 bei, entferne die restlichen
                new_lines.append(line)
                skip_count += 1
            else:
                continue  # Überspringe überflüssige Klammern
        else:
            new_lines.append(line)
    else:
        new_lines.append(line)

with open('lib/components/jackpot_overview_screen.dart', 'w') as f:
    f.writelines(new_lines)

print("✅ Struktureller Fehler behoben - überflüssige Klammern entfernt")
