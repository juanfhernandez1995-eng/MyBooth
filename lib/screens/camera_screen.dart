import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  final String eventId;

  const CameraScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Mode'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          'The Camera View will go here!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}