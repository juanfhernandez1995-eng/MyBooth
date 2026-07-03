import 'package:flutter/material.dart';

class DisplayScreen extends StatelessWidget {
  final String eventId;

  const DisplayScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Mode'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          'The QR Code will go here!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}