import 'package:flutter/material.dart';

import '../models/event.dart';

class EventSummaryCard extends StatelessWidget {
  final BoothEvent event;
  final bool compact;

  const EventSummaryCard({
    super.key,
    required this.event,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  child: Icon(
                    Icons.event_available,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.displayName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 3),
                      Text('${event.occasion} • ${event.statusLabel}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _SummaryRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: event.displayDate,
            ),
            _SummaryRow(
              icon: Icons.palette,
              label: 'Theme',
              value: event.eventTheme,
            ),
            _SummaryRow(
              icon: Icons.photo_size_select_actual,
              label: 'Layout',
              value: event.photoLayout,
            ),
            _SummaryRow(
              icon: Icons.print,
              label: 'Prints',
              value: '${event.printCopies} ${event.printCopies == 1 ? 'copy' : 'copies'}',
            ),
            if (!compact) ...[
              _SummaryRow(
                icon: Icons.person,
                label: 'Customer',
                value: event.customerName.trim().isEmpty ? 'Not provided' : event.customerName,
              ),
              _SummaryRow(
                icon: Icons.email,
                label: 'Email',
                value: event.customerEmail.trim().isEmpty ? 'Not provided' : event.customerEmail,
              ),
              _SummaryRow(
                icon: Icons.cloud_upload,
                label: 'Guest uploads',
                value: event.guestUploadsEnabled ? 'Enabled' : 'Disabled',
              ),
              _SummaryRow(
                icon: Icons.send,
                label: 'Follow-up',
                value: event.sendGalleryTomorrow ? 'Send gallery tomorrow' : 'No scheduled follow-up',
              ),
              if (event.notes.trim().isNotEmpty)
                _SummaryRow(
                  icon: Icons.notes,
                  label: 'Notes',
                  value: event.notes,
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: colorScheme.primary),
          const SizedBox(width: 10),
          SizedBox(
            width: 96,
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
