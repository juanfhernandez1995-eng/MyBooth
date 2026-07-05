import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/event.dart';
import '../providers/event_provider.dart';
import '../screens/event_detail_screen.dart';
import 'empty_state.dart';

class RecentEventsCard extends StatelessWidget {
  const RecentEventsCard({super.key});

  Future<void> _confirmDelete(BuildContext context, BoothEvent event) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Event?'),
          content: Text('Delete ${event.displayName}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && context.mounted) {
      await context.read<EventProvider>().deleteEvent(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    final events = context.watch<EventProvider>().events;

    if (events.isEmpty) {
      return const EmptyState(
        icon: Icons.event_available,
        title: 'No events yet',
        message: 'Create your first MyBooth event to get started.',
      );
    }

    return ListView.separated(
      itemCount: events.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final event = events[index];

        return _RecentEventTile(
          event: event,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventDetailScreen(eventId: event.id),
              ),
            );
          },
          onDelete: () => _confirmDelete(context, event),
        );
      },
    );
  }
}

class _RecentEventTile extends StatelessWidget {
  final BoothEvent event;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _RecentEventTile({
    required this.event,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        leading: Icon(Icons.event, color: colorScheme.primary),
        title: Text(
          event.displayName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${event.occasion} • ${event.statusLabel}\n${event.eventTheme} • ${event.displayDate}',
        ),
        isThreeLine: true,
        onTap: onTap,
        trailing: IconButton(
          tooltip: 'Delete event',
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
