import 'package:flutter/material.dart';

import '../models/event.dart';
import '../widgets/app_page.dart';
import '../widgets/event_summary_card.dart';
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
      appBar: AppBar(title: const Text('Choose Station')),
      body: AppPage(
        maxWidth: 720,
        child: ListView(
          children: [
            EventSummaryCard(event: event, compact: true),
            const SizedBox(height: 24),
            Text(
              'Which station is this device?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'The tablet chooses the interface. The MyBooth Server laptop still controls the camera, printer, AI engine, and event storage.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _StationButton(
              icon: Icons.camera_alt,
              label: 'Camera Station',
              subtitle: 'Capture flow placeholder for Canon EOS R50 control.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CameraScreen(eventId: event.id),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _StationButton(
              icon: Icons.qr_code_2,
              label: 'Display Station',
              subtitle: 'Gallery and QR display placeholder.',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DisplayScreen(eventId: event.id),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StationButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onPressed;

  const _StationButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        icon: Icon(icon),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(subtitle),
            ],
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
