import 'package:flutter/material.dart';

Widget buildNumberChip(int number, {bool isBonus = false, Color? primaryColor, bool isBall = true}) {
  if (isBall) {
    // Kugel-Form für Lottozahlen
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isBonus ? Colors.orange.shade400 : (primaryColor ?? Colors.blue.shade400),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  } else {
    // Rechteckige Form für andere Zahlen
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isBonus ? Colors.orange.shade200 : (primaryColor ?? Colors.blue.shade200),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isBonus ? Colors.orange.shade400 : (primaryColor ?? Colors.blue.shade400),
          width: 2,
        ),
      ),
      child: Text(
        number.toString(),
        style: TextStyle(
          color: isBonus ? Colors.orange.shade900 : Colors.blue.shade900,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

Widget buildHistoryNumberChip(int number, Color primaryColor) {
  // Tipphistorie: Immer rechteckig, keine Kugeln
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: primaryColor,
        width: 1,
      ),
    ),
    child: Text(
      number.toString(),
      style: TextStyle(
        color: Colors.grey.shade800,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
    ),
  );
}

Widget buildStatsNumberChip(int number, {bool isHot = true, bool isBonus = false}) {
  // Statistik-Zahlen: Mit Abstand für Bonus-Zahlen
  return Container(
    margin: isBonus ? const EdgeInsets.only(right: 16) : EdgeInsets.zero,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: isBonus 
          ? Colors.purple.shade200 
          : (isHot ? Colors.red.shade200 : Colors.blue.shade200),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: isBonus 
            ? Colors.purple.shade400 
            : (isHot ? Colors.red.shade400 : Colors.blue.shade400),
        width: 2,
      ),
    ),
    child: Text(
      number.toString(),
      style: TextStyle(
        color: isBonus 
            ? Colors.purple.shade900 
            : (isHot ? Colors.red.shade900 : Colors.blue.shade900),
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
