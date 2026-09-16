import 'package:flutter/material.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerState();
}

class _ScannerState extends State<ScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(child: Center(child: Text('SCANNER SCREEN'))),
    );
  }
}
