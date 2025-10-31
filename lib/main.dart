import 'package:flutter/material.dart';
import 'components/disclimber_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Lotto World Pro',
      home: DisclimberWrapper(),
    );
  }
}
