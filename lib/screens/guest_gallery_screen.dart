import 'package:flutter/material.dart';

import '../models/event.dart';
import '../models/gallery_session.dart';
import '../widgets/app_page.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_card.dart';

class GuestGalleryScreen extends StatelessWidget {
  final BoothEvent event;

  const GuestGalleryScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final session = GuestGallerySession.fromEvent(event);

    return Scaffold(
      appBar: AppBar(title: const Text('Guest Gallery')),
      body: AppPage(
        maxWidth: 760,
        child: ListView(
          children: [
            _GalleryHero(session: session),
            const SizedBox(height: 18),
            _FinalPhotoCard(session: session),
            const SizedBox(height: 18),
            _DownloadCard(session: session),
            const SizedBox(height: 18),
            _OperatorBoundaryCard(session: session),
          ],
        ),
      ),
    );
  }
}

class _GalleryHero extends StatelessWidget {
  final GuestGallerySession session;

  const _GalleryHero({required this.session});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SectionCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.photo_library_rounded, size: 72, color: colorScheme.primary),
          const SizedBox(height: 14),
          Text(
            '${session.eventName} Gallery',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            session.honoreeName.isEmpty ? session.eventDate : '${session.honoreeName} • ${session.eventDate}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              Chip(avatar: const Icon(Icons.filter_frames, size: 18), label: Text(session.templateName)),
              Chip(avatar: const Icon(Icons.photo_size_select_actual, size: 18), label: Text(session.layoutName)),
            ],
          ),
          const SizedBox(height: 16),
          SelectableText(
            session.guestGalleryUrl,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

class _FinalPhotoCard extends StatelessWidget {
  final GuestGallerySession session;

  const _FinalPhotoCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final finalAsset = session.visibleGuestAssets.first;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Final Guest Photo',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('This is the QR destination guests should see after the booth session.'),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary.withValues(alpha: 0.16),
                  colorScheme.secondary.withValues(alpha: 0.10),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.25)),
            ),
            child: Column(
              children: [
                _PhotoPlaceholder(session: session),
                const SizedBox(height: 14),
                Text(
                  finalAsset.fileName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(finalAsset.relativePath),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  final GuestGallerySession session;

  const _PhotoPlaceholder({required this.session});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isGrid = session.layoutName.contains('4x6');

    final preview = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colorScheme.primary, width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0x22000000), blurRadius: 16, offset: Offset(0, 8)),
        ],
      ),
      child: isGrid ? _GridPreview(session: session) : _StripPreview(session: session),
    );

    if (isGrid) {
      return AspectRatio(aspectRatio: 1.45, child: preview);
    }

    return Center(
      child: SizedBox(
        width: 220,
        height: 520,
        child: preview,
      ),
    );
  }
}

class _StripPreview extends StatelessWidget {
  final GuestGallerySession session;

  const _StripPreview({required this.session});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _MiniPhotoSlot(label: 'Photo 1')),
        Expanded(child: _MiniPhotoSlot(label: 'Photo 2')),
        Expanded(child: _MiniPhotoSlot(label: 'Photo 3')),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            session.honoreeName.isEmpty ? session.eventName : session.honoreeName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _GridPreview extends StatelessWidget {
  final GuestGallerySession session;

  const _GridPreview({required this.session});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: const [
                _MiniPhotoSlot(label: 'Photo 1'),
                _MiniPhotoSlot(label: 'Photo 2'),
                _MiniPhotoSlot(label: 'Photo 3'),
                _MiniPhotoSlot(label: 'Photo 4'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            session.eventName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _MiniPhotoSlot extends StatelessWidget {
  final String label;

  const _MiniPhotoSlot({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(label, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}

class _DownloadCard extends StatelessWidget {
  final GuestGallerySession session;

  const _DownloadCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Guest Delivery',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(session.deliveryNote),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Download Final Photo',
            icon: Icons.download,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download is a placeholder until real final image generation is connected.')),
              );
            },
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.ios_share),
            label: const Text('Share / Google Photos Export Later'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Google Photos export will upload final bordered outputs only in a later release.')),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OperatorBoundaryCard extends StatelessWidget {
  final GuestGallerySession session;

  const _OperatorBoundaryCard({required this.session});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Operator-Only Originals',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('These folders stay private on the laptop server and are not shown through guest QR links.'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: session.operatorOnlyFolders.map((folder) => Chip(label: Text(folder))).toList(),
          ),
        ],
      ),
    );
  }
}
