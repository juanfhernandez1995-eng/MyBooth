import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../providers/event_provider.dart';
import '../widgets/app_page.dart';
import '../widgets/event_summary_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/section_card.dart';
import 'booth_mode_screen.dart';
import 'device_selection_screen.dart';
import 'guest_gallery_screen.dart';
import 'template_designer_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;

  const EventDetailScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    final event = context.watch<EventProvider>().getEventById(eventId);

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Event')),
        body: const AppPage(
          child: Center(child: Text('This event could not be found.')),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: AppPage(
        maxWidth: 760,
        child: ListView(
          children: [
            EventSummaryCard(event: event),
            const SizedBox(height: 18),
            _TemplatePlanCard(event: event),
            const SizedBox(height: 18),
            _CapturePlanCard(event: event),
            const SizedBox(height: 18),
            _StoragePlanCard(event: event),
            const SizedBox(height: 18),
            _EventReadinessCard(event: event),
            const SizedBox(height: 18),
            PrimaryButton(
              text: 'Design Event Template',
              icon: Icons.design_services,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TemplateDesignerScreen(eventId: event.id),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              text: 'Start Booth Mode',
              icon: Icons.photo_camera_front,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BoothModeScreen(event: event),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.qr_code_2),
              label: const Text('Preview Guest Gallery + QR'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => GuestGalleryScreen(event: event),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.tune),
              label: const Text('Continue Setup'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeviceSelectionScreen(event: event),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Mark Ready'),
              onPressed: event.status == EventStatus.ready
                  ? null
                  : () {
                      context.read<EventProvider>().updateEvent(
                            event.copyWith(status: EventStatus.ready),
                          );
                    },
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplatePlanCard extends StatelessWidget {
  final BoothEvent event;

  const _TemplatePlanCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
            icon: Icons.filter_frames,
            title: 'Template + Border Plan',
            subtitle: 'Editable event border information that will drive future 2x6 and 4x6 rendering.',
          ),
          const SizedBox(height: 12),
          _InfoRow(label: 'Template', value: event.templateSummary),
          _InfoRow(label: 'Category', value: event.templateCategory),
          _InfoRow(label: 'Event title', value: event.displayName),
          _InfoRow(label: 'Honoree / Name', value: event.displayHonoree.isEmpty ? 'Not set' : event.displayHonoree),
          _InfoRow(label: 'Subtitle', value: event.eventSubtitle.isEmpty ? 'Not set' : event.eventSubtitle),
          _InfoRow(label: 'Background Pack', value: event.backgroundPackName),
          _InfoRow(label: 'Green Screen', value: event.greenScreenEnabled ? 'Enabled' : 'Off'),
        ],
      ),
    );
  }
}

class _CapturePlanCard extends StatelessWidget {
  final BoothEvent event;

  const _CapturePlanCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final settings = event.captureSettings;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
            icon: Icons.timer,
            title: 'Capture Countdown Plan',
            subtitle: 'Guest-facing one-screen booth countdown settings for 2x6 strips and 4x6 grids.',
          ),
          const SizedBox(height: 12),
          _InfoRow(label: 'Countdown', value: '${settings.countdownSeconds} seconds'),
          _InfoRow(label: 'Between strip photos', value: '${settings.delayBetweenPhotosSeconds} seconds'),
          _InfoRow(label: 'Smile message', value: settings.showSmileMessage ? 'On' : 'Off'),
          _InfoRow(label: 'Flash screen effect', value: settings.flashScreenEnabled ? 'On' : 'Off'),
          _InfoRow(label: 'Sound effects', value: settings.soundEnabled ? 'On' : 'Off'),
          _InfoRow(label: 'Retakes', value: settings.retakeEnabled ? 'Allowed' : 'Disabled'),
        ],
      ),
    );
  }
}

class _StoragePlanCard extends StatelessWidget {
  final BoothEvent event;

  const _StoragePlanCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final slug = event.displayName.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-|-$'), '');

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
            icon: Icons.folder_copy,
            title: 'Photo Storage Plan',
            subtitle: 'Original captures will never be overwritten; processed, composited, bordered, print, and gallery files are saved separately.',
          ),
          const SizedBox(height: 12),
          _InfoRow(label: 'Event folder', value: 'mybooth_data/events/${slug.isEmpty ? event.id : slug}'),
          const SizedBox(height: 8),
          const Text('Planned folders:'),
          const SizedBox(height: 8),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text('captures/original')),
              Chip(label: Text('captures/composited')),
              Chip(label: Text('captures/bordered')),
              Chip(label: Text('prints/strips')),
              Chip(label: Text('gallery/final')),
              Chip(label: Text('gallery/qr')),
              Chip(label: Text('logs')),
            ],
          ),
        ],
      ),
    );
  }
}

class _EventReadinessCard extends StatelessWidget {
  final BoothEvent event;

  const _EventReadinessCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final readinessItems = [
      _ReadinessItem(
        title: 'Event profile',
        isReady: event.eventName.trim().isNotEmpty,
        detail: 'Event name and occasion are saved.',
      ),
      _ReadinessItem(
        title: 'Customer info',
        isReady: event.customerName.trim().isNotEmpty || event.customerEmail.trim().isNotEmpty,
        detail: 'Customer name or email is available.',
      ),
      _ReadinessItem(
        title: 'Template selected',
        isReady: event.templateId.trim().isNotEmpty,
        detail: event.templateSummary,
      ),
      _ReadinessItem(
        title: 'Countdown configured',
        isReady: event.captureSettings.countdownSeconds > 0,
        detail: event.captureSummary,
      ),
      _ReadinessItem(
        title: 'Print setup',
        isReady: event.printCopies > 0,
        detail: '${event.photoLayout}, ${event.printCopies} copies.',
      ),
    ];

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Setup Readiness',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...readinessItems.map((item) => _ReadinessTile(item: item)),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _CardTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              Text(subtitle),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _ReadinessItem {
  final String title;
  final bool isReady;
  final String detail;

  const _ReadinessItem({
    required this.title,
    required this.isReady,
    required this.detail,
  });
}

class _ReadinessTile extends StatelessWidget {
  final _ReadinessItem item;

  const _ReadinessTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        item.isReady ? Icons.check_circle : Icons.info_outline,
        color: item.isReady ? colorScheme.primary : colorScheme.secondary,
      ),
      title: Text(item.title),
      subtitle: Text(item.detail),
    );
  }
}
