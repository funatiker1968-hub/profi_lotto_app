import 'package:flutter/material.dart';

Widget buildNumberChip(int number, {bool isBonus = false, Color? primaryColor}) {
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

Widget buildHistoryNumberChip(int number, Color primaryColor) {
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
