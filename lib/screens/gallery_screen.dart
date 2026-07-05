import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/gallery_session.dart';
import '../providers/event_provider.dart';
import '../widgets/app_page.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_card.dart';
import 'guest_gallery_screen.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final events = context.watch<EventProvider>().events;

    return Scaffold(
      appBar: AppBar(title: const Text('Gallery + QR')),
      body: AppPage(
        maxWidth: 760,
        child: events.isEmpty
            ? const EmptyState(
                icon: Icons.photo_library_outlined,
                title: 'No galleries yet',
                message: 'Create an event and run Booth Mode to prepare a final guest gallery.',
              )
            : ListView(
                children: [
                  const _GalleryIntroCard(),
                  const SizedBox(height: 18),
                  ...events.map((event) {
                    final session = GuestGallerySession.fromEvent(event);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _GallerySessionCard(
                        session: session,
                        onOpen: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GuestGalleryScreen(event: event),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
      ),
    );
  }
}

class _GalleryIntroCard extends StatelessWidget {
  const _GalleryIntroCard();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.qr_code_2, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Guest QR Gallery Foundation',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'QR codes should take guests to final bordered/composited photos only. Raw Canon originals stay operator-only on the laptop server.',
          ),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text('gallery/final')),
              Chip(label: Text('gallery/qr')),
              Chip(label: Text('download placeholder')),
              Chip(label: Text('Google Photos later')),
            ],
          ),
        ],
      ),
    );
  }
}

class _GallerySessionCard extends StatelessWidget {
  final GuestGallerySession session;
  final VoidCallback onOpen;

  const _GallerySessionCard({
    required this.session,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(Icons.photo_album, color: colorScheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.eventName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(session.honoreeName.isEmpty ? session.eventDate : '${session.honoreeName} • ${session.eventDate}'),
                    const SizedBox(height: 4),
                    Text('${session.layoutName} • ${session.templateName}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SelectableText(
            session.guestGalleryUrl,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.primary),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Guest Gallery Preview'),
              onPressed: onOpen,
            ),
          ),
        ],
      ),
    );
  }
}
