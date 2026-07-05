import 'package:flutter/material.dart';

import '../widgets/app_page.dart';

class DisplayScreen extends StatelessWidget {
  final String eventId;

  const DisplayScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display Station')),
      body: AppPage(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_2,
              size: 76,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 18),
            Text(
              'Guest Gallery Display',
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
              'QR gallery and live event display will connect through the MyBooth Server.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
