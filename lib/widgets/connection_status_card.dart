import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/local_connection.dart';
import '../providers/local_connection_provider.dart';
import 'section_card.dart';

class ConnectionStatusCard extends StatelessWidget {
  final VoidCallback onOpenConnection;

  const ConnectionStatusCard({
    super.key,
    required this.onOpenConnection,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocalConnectionProvider>();
    final connection = provider.connection;

    if (provider.isLoading && connection == null) {
      return const SectionCard(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final effectiveConnection = connection ?? LocalConnection.defaultConnection();
    final color = _stateColor(effectiveConnection.state);

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.hub, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Server Pairing',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              _ConnectionBadge(
                label: effectiveConnection.stateLabel,
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            effectiveConnection.pairingSummary,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            effectiveConnection.message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6B7280),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            effectiveConnection.routerPairingTip,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: effectiveConnection.isConnected ? Colors.green : const Color(0xFF6B7280),
                  fontWeight: FontWeight.w700,
                ),
          ),
          if (effectiveConnection.lastError != null && effectiveConnection.lastError!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Check Wi-Fi, server address, and firewall if pairing fails.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onOpenConnection,
              icon: const Icon(Icons.settings_ethernet),
              label: const Text('Pairing Details'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConnectionBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _ConnectionBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

Color _stateColor(LocalConnectionState state) {
  switch (state) {
    case LocalConnectionState.notConfigured:
      return Colors.orange;
    case LocalConnectionState.configured:
      return Colors.blue;
    case LocalConnectionState.checking:
      return Colors.purple;
    case LocalConnectionState.connected:
      return Colors.green;
    case LocalConnectionState.failed:
      return Colors.red;
  }
}
