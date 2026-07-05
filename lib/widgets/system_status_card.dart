import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/server_module.dart';
import '../providers/server_status_provider.dart';
import 'section_card.dart';

class SystemStatusCard extends StatelessWidget {
  final VoidCallback? onViewDetails;

  const SystemStatusCard({
    super.key,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServerStatusProvider>();
    final status = provider.status;

    if (provider.isLoading || status == null) {
      return const SectionCard(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final primaryModules = [
      status.moduleByType(ServerModuleType.myBoothServer),
      status.moduleByType(ServerModuleType.tabletClient),
      status.moduleByType(ServerModuleType.camera),
      status.moduleByType(ServerModuleType.printer),
    ];

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.hub),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Server Foundation',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              _ReadinessBadge(label: status.readinessLabel),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${status.connectionMode} • ${status.serverAddress}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6B7280),
                ),
          ),
          const SizedBox(height: 14),
          ...primaryModules.map(
            (module) => _StatusRow(module: module),
          ),
          if (onViewDetails != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onViewDetails,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Server Details'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReadinessBadge extends StatelessWidget {
  final String label;

  const _ReadinessBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

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

class _StatusRow extends StatelessWidget {
  final ServerModule module;

  const _StatusRow({required this.module});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(module.status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(_moduleIcon(module.type), color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              module.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            module.statusLabel,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

IconData _moduleIcon(ServerModuleType type) {
  switch (type) {
    case ServerModuleType.myBoothServer:
      return Icons.computer;
    case ServerModuleType.tabletClient:
      return Icons.tablet_android;
    case ServerModuleType.privateNetwork:
      return Icons.wifi;
    case ServerModuleType.camera:
      return Icons.camera_alt;
    case ServerModuleType.printer:
      return Icons.print;
    case ServerModuleType.aiEngine:
      return Icons.auto_awesome;
    case ServerModuleType.galleryStorage:
      return Icons.photo_library;
  }
}

Color _statusColor(ServerModuleStatus status) {
  switch (status) {
    case ServerModuleStatus.ready:
      return Colors.green;
    case ServerModuleStatus.planned:
      return Colors.orange;
    case ServerModuleStatus.offline:
      return Colors.red;
    case ServerModuleStatus.attention:
      return Colors.blue;
  }
}
