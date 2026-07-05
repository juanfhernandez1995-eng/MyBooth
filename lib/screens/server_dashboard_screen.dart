import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/server_module.dart';
import '../providers/server_status_provider.dart';
import '../widgets/app_page.dart';
import '../widgets/section_card.dart';

class ServerDashboardScreen extends StatelessWidget {
  const ServerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServerStatusProvider>();
    final status = provider.status;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyBooth Server'),
        actions: [
          IconButton(
            tooltip: 'Refresh status',
            onPressed: provider.isLoading ? null : provider.refreshStatus,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: AppPage(
        maxWidth: 820,
        child: status == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  _ServerHeroCard(
                    serverName: status.serverName,
                    connectionMode: status.connectionMode,
                    serverAddress: status.serverAddress,
                    readinessLabel: status.readinessLabel,
                    readinessPercent: status.readinessPercent,
                  ),
                  const SizedBox(height: 18),
                  _ArchitectureCard(lastChecked: status.lastChecked),
                  const SizedBox(height: 18),
                  Text(
                    'Server Modules',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  ...status.modules.map(
                    (module) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ServerModuleCard(module: module),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ServerHeroCard extends StatelessWidget {
  final String serverName;
  final String connectionMode;
  final String serverAddress;
  final String readinessLabel;
  final double readinessPercent;

  const _ServerHeroCard({
    required this.serverName,
    required this.connectionMode,
    required this.serverAddress,
    required this.readinessLabel,
    required this.readinessPercent,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                child: Icon(
                  Icons.hub,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serverName,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(connectionMode),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LinearProgressIndicator(value: readinessPercent),
          const SizedBox(height: 10),
          Text(
            readinessLabel,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            serverAddress,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6B7280),
                ),
          ),
        ],
      ),
    );
  }
}

class _ArchitectureCard extends StatelessWidget {
  final DateTime lastChecked;

  const _ArchitectureCard({required this.lastChecked});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Architecture Direction',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          const _ArchitectureStep(
            icon: Icons.tablet_android,
            title: 'Android Tablet',
            detail: 'Runs the MyBooth client interface in vertical orientation.',
          ),
          const _ArchitectureConnector(),
          const _ArchitectureStep(
            icon: Icons.wifi,
            title: 'Private Wi-Fi',
            detail: 'Keeps booth communication local and controlled by the operator.',
          ),
          const _ArchitectureConnector(),
          const _ArchitectureStep(
            icon: Icons.computer,
            title: 'Gaming Laptop Server',
            detail: 'Owns camera, printer, AI engine, local gallery, and event storage.',
          ),
          const SizedBox(height: 12),
          Text(
            'Last checked: ${lastChecked.month}/${lastChecked.day}/${lastChecked.year} ${lastChecked.hour.toString().padLeft(2, '0')}:${lastChecked.minute.toString().padLeft(2, '0')}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ArchitectureStep extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;

  const _ArchitectureStep({
    required this.icon,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(detail),
            ],
          ),
        ),
      ],
    );
  }
}

class _ArchitectureConnector extends StatelessWidget {
  const _ArchitectureConnector();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 11, top: 4, bottom: 4),
      child: Container(
        width: 2,
        height: 20,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
      ),
    );
  }
}

class _ServerModuleCard extends StatelessWidget {
  final ServerModule module;

  const _ServerModuleCard({required this.module});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(module.status);

    return SectionCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(_moduleIcon(module.type), color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  module.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(module.description),
                const SizedBox(height: 8),
                Text(
                  module.detail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _ModuleStatusPill(
            label: module.statusLabel,
            color: color,
          ),
        ],
      ),
    );
  }
}

class _ModuleStatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _ModuleStatusPill({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 130),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
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
