import 'package:flutter/material.dart';
import '../models/event.dart';
import 'camera_screen.dart';
import 'display_screen.dart';

class DeviceSelectionScreen extends StatelessWidget {
  final BoothEvent event;

  const DeviceSelectionScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Station"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              event.eventName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Which station is this device?",
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text("Camera Station"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CameraScreen(eventId: event.id),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.qr_code_2),
                label: const Text("Display Station"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DisplayScreen(eventId: event.id),
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