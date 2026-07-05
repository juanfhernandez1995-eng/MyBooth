import 'package:flutter/material.dart';

import '../widgets/app_page.dart';

class CameraScreen extends StatelessWidget {
  final String eventId;

  const CameraScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Station')),
      body: AppPage(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt,
              size: 72,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 18),
            Text(
              'Canon EOS R50 Control',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Event ID: $eventId',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 14),
            const Text(
              'Live camera control will connect through the MyBooth Server.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
